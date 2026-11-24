extends Node

## AudioManager
## Arka plan müziği, teşvik edici ses efektleri ve Türkçe seslendirmeleri yönetir.

var bgm_player: AudioStreamPlayer
var voice_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE: int = 6

var current_voice_callback: Callable = Callable()

# Ses önbelleği
var sfx_cache: Dictionary = {}
var voice_cache: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_audio_players()

func _setup_audio_players() -> void:
	# BGM Çalıcısı
	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "BGMPlayer"
	bgm_player.bus = "Master"
	bgm_player.volume_db = -10.0
	add_child(bgm_player)

	# Seslendirme Çalıcısı (Voice)
	voice_player = AudioStreamPlayer.new()
	voice_player.name = "VoicePlayer"
	voice_player.bus = "Master"
	voice_player.finished.connect(_on_voice_finished)
	add_child(voice_player)

	# SFX Havuzu
	for i in range(SFX_POOL_SIZE):
		var p = AudioStreamPlayer.new()
		p.name = "SFXPlayer_%d" % i
		p.bus = "Master"
		add_child(p)
		sfx_players.append(p)

func play_sfx(sound_resource: Variant, pitch_scale: float = 1.0) -> void:
	var stream: AudioStream = null
	if sound_resource is AudioStream:
		stream = sound_resource
	elif sound_resource is String:
		stream = _get_or_load_sfx(sound_resource)
	
	if not stream:
		return

	# Boşta olan çalıcıyı bul
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.pitch_scale = pitch_scale
			p.play()
			return

	# Hepsi meşgulse ilkini yeniden kullan
	sfx_players[0].stream = stream
	sfx_players[0].pitch_scale = pitch_scale
	sfx_players[0].play()

func play_voice(voice_resource: Variant, on_finished: Callable = Callable()) -> void:
	var stream: AudioStream = null
	if voice_resource is AudioStream:
		stream = voice_resource
	elif voice_resource is String:
		stream = _get_or_load_voice(voice_resource)

	current_voice_callback = on_finished

	if not stream:
		if current_voice_callback.is_valid():
			current_voice_callback.call()
			current_voice_callback = Callable()
		return

	if voice_player.playing:
		voice_player.stop()

	voice_player.stream = stream
	voice_player.play()

func stop_voice() -> void:
	if voice_player.playing:
		voice_player.stop()
	current_voice_callback = Callable()

func is_voice_playing() -> bool:
	return voice_player.playing

func _on_voice_finished() -> void:
	if current_voice_callback.is_valid():
		var cb = current_voice_callback
		current_voice_callback = Callable()
		cb.call()

func _get_or_load_sfx(path: String) -> AudioStream:
	if sfx_cache.has(path):
		return sfx_cache[path]
	if ResourceLoader.exists(path):
		var res = load(path)
		if res is AudioStream:
			sfx_cache[path] = res
			return res
	return null

func _get_or_load_voice(path: String) -> AudioStream:
	if voice_cache.has(path):
		return voice_cache[path]
	if ResourceLoader.exists(path):
		var res = load(path)
		if res is AudioStream:
			voice_cache[path] = res
			return res
	return null

## Çocuk oyunu için dinamik tatlı synth sesleri (dosya olmadığında bile çalışır)
func play_gentle_bell() -> void:
	# 880Hz tatlı onay tonu
	_play_procedural_tone(880.0, 0.25, 0.3)

func play_success_jingle() -> void:
	_play_procedural_chime([523.25, 659.25, 783.99, 1046.50]) # C5, E5, G5, C6

func play_star_sound() -> void:
	_play_procedural_tone(1174.66, 0.3, 0.35) # D6 ışıltısı

func play_tap_sound() -> void:
	_play_procedural_tone(440.0, 0.08, 0.2)

func _play_procedural_tone(freq: float, duration: float, volume: float = 0.5) -> void:
	var sample_rate = 22050
	var sample_count = int(sample_rate * duration)
	var data = PackedByteArray()
	data.resize(sample_count * 2) # 16-bit mono

	for i in range(sample_count):
		var t = float(i) / sample_rate
		var envelope = 1.0 - (float(i) / sample_count) # Basit sönümleme
		var wave = sin(2.0 * PI * freq * t) * envelope * volume
		var sample_val = int(clamp(wave * 32767.0, -32768.0, 32767.0))
		data.encode_s16(i * 2, sample_val)

	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = data
	play_sfx(wav)

func _play_procedural_chime(notes: Array) -> void:
	for i in range(notes.size()):
		var freq = notes[i]
		get_tree().create_timer(i * 0.09).timeout.connect(func():
			_play_procedural_tone(freq, 0.22, 0.35)
		)
