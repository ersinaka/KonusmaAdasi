extends Node

## RecordManager
## Çocukların seslerini yerel (offline) olarak güvenle kaydeder, çalar ve siler.
## Gizlilik esastır: Hiçbir ses internete yüklenmez, tanı konulmaz.

signal recording_started
signal recording_stopped(stream: AudioStreamWAV)
signal recording_saved(filepath: String)
signal playback_started
signal playback_finished
signal error_occurred(message: String)

const RECORDINGS_DIR: String = "user://recordings/"
const RECORD_BUS_NAME: String = "Record"

var record_effect: AudioEffectRecord = null
var current_recording: AudioStreamWAV = null
var playback_player: AudioStreamPlayer = null
var is_recording: bool = false
var last_saved_file_path: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_directories()
	_setup_audio_bus_and_player()

func _setup_directories() -> void:
	var dir = DirAccess.open("user://")
	if dir and not dir.dir_exists("recordings"):
		dir.make_dir("recordings")
		print("Kayıtlar dizini oluşturuldu: %s" % RECORDINGS_DIR)

func _setup_audio_bus_and_player() -> void:
	# Oynatıcı düğümü
	playback_player = AudioStreamPlayer.new()
	playback_player.name = "RecordPlaybackPlayer"
	playback_player.bus = "Master"
	playback_player.finished.connect(_on_playback_finished)
	add_child(playback_player)

	# Record veriyolunu bul
	var bus_index = AudioServer.get_bus_index(RECORD_BUS_NAME)
	if bus_index == -1:
		push_warning("'%s' ses veriyolu bulunamadı. Kayıt fonksiyonu aktif olmayabilir." % RECORD_BUS_NAME)
		return

	# Efekti al
	for i in range(AudioServer.get_bus_effect_count(bus_index)):
		var effect = AudioServer.get_bus_effect(bus_index, i)
		if effect is AudioEffectRecord:
			record_effect = effect
			break

	if not record_effect:
		push_warning("'%s' veriyolunda AudioEffectRecord efekti bulunamadı." % RECORD_BUS_NAME)

func is_microphone_available() -> bool:
	var input_devices = AudioServer.get_input_device_list()
	return input_devices.size() > 0 and record_effect != null

func start_recording() -> bool:
	if is_recording:
		push_warning("Zaten bir ses kaydı devam ediyor.")
		return false

	if not is_microphone_available():
		error_occurred.emit("Mikrofon bulunamadı veya kullanılamıyor.")
		return false

	if playback_player.playing:
		playback_player.stop()

	current_recording = null
	record_effect.set_recording_active(true)
	is_recording = true
	recording_started.emit()
	print("Mikrofon kaydı başladı...")
	return true

func stop_recording() -> AudioStreamWAV:
	if not is_recording or not record_effect:
		return null

	is_recording = false
	current_recording = record_effect.get_recording()
	record_effect.set_recording_active(false)

	if current_recording:
		print("Mikrofon kaydı tamamlandı. Örnek sayısı: %d" % current_recording.data.size())
		recording_stopped.emit(current_recording)
	else:
		push_warning("Kayıt verisi boş döndü.")
		error_occurred.emit("Ses kaydedilemedi.")

	return current_recording

func save_recording(activity_id: String) -> String:
	if not current_recording or current_recording.data.size() == 0:
		error_occurred.emit("Kaydedilecek geçerli bir ses yok.")
		return ""

	var timestamp = Time.get_datetime_string_from_system().replace(":", "-").replace("T", "_")
	var filename = "%s_%s.wav" % [activity_id, timestamp]
	var filepath = RECORDINGS_DIR + filename

	var err = current_recording.save_to_wav(filepath)
	if err == OK:
		last_saved_file_path = filepath
		recording_saved.emit(filepath)
		print("Kayıt başarıyla kaydedildi: %s" % filepath)
		return filepath
	else:
		push_error("Kayıt dosyası kaydedilemedi. Hata kodu: %d" % err)
		error_occurred.emit("Ses dosyası diske yazılamadı.")
		return ""

func play_recording(stream: AudioStreamWAV = null) -> bool:
	var stream_to_play = stream if stream else current_recording
	if not stream_to_play or stream_to_play.data.size() == 0:
		push_warning("Oynatılacak ses kaydı yok.")
		return false

	playback_player.stream = stream_to_play
	playback_player.play()
	playback_started.emit()
	return true

func play_recording_file(filepath: String) -> bool:
	if not FileAccess.file_exists(filepath):
		error_occurred.emit("Kayıt dosyası bulunamadı.")
		return false

	var file = FileAccess.open(filepath, FileAccess.READ)
	if not file:
		return false
	var bytes = file.get_buffer(file.get_length())
	file.close()

	var wav = AudioStreamWAV.new()
	wav.data = bytes
	return play_recording(wav)

func stop_playback() -> void:
	if playback_player.playing:
		playback_player.stop()
		playback_finished.emit()

func is_playing() -> bool:
	return playback_player.playing

func delete_current_recording() -> void:
	if playback_player.playing:
		playback_player.stop()

	if last_saved_file_path != "" and FileAccess.file_exists(last_saved_file_path):
		var dir = DirAccess.open(RECORDINGS_DIR)
		if dir:
			dir.remove(last_saved_file_path.get_file())
			print("Kayıt dosyası silindi: %s" % last_saved_file_path)

	current_recording = null
	last_saved_file_path = ""
	playback_finished.emit()

func _on_playback_finished() -> void:
	playback_finished.emit()
