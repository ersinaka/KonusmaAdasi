extends Control

## PapaganiKonustur (Mini-Game 2)
## Kelime Köyü - Papağan Piko ile telaffuz, dinleme ve yüksek kaliteli konuşma pratiği.
## Not: Oyun içi ses kaydı kaldırılmıştır; çocuk Piko'yu dinler ve birlikte neşeyle tekrar eder.

@onready var nav_bar: Control = $NavBar
@onready var piko_rect: TextureRect = $TopSection/PikoRect
@onready var prompt_label: Label = $TopSection/PromptBubble/Margin/HBox/PromptLabel
@onready var listen_target_btn: TextureButton = $TopSection/PromptBubble/Margin/HBox/SpeakerBtn

@onready var word_image: TextureRect = $CenterContent/WordCard/Margin/VBox/WordImage
@onready var word_label: Label = $CenterContent/WordCard/Margin/VBox/WordLabel

@onready var listen_again_btn: Button = $ControlsPanel/ActionBox/ListenAgainBtn
@onready var repeat_out_loud_btn: Button = $ControlsPanel/ActionBox/RepeatOutLoudBtn
@onready var next_word_btn: Button = $ControlsPanel/ActionBox/NextWordBtn
@onready var status_label: Label = $ControlsPanel/StatusLabel

@onready var reward_dialog: Control = $RewardDialog
@onready var success_overlay: Control = $SuccessOverlay

var word_items: Array = []
var current_index: int = 0
var total_rounds: int = 4
var current_target: Dictionary = {}

func _ready() -> void:
	nav_bar.set_title("Papağanı Konuştur 🦜")
	nav_bar.home_requested.connect(_on_home_pressed)
	nav_bar.repeat_voice_requested.connect(_play_target_word)
	listen_target_btn.pressed.connect(_play_target_word)

	listen_again_btn.pressed.connect(_on_listen_again_pressed)
	repeat_out_loud_btn.pressed.connect(_on_repeat_out_loud_pressed)
	next_word_btn.pressed.connect(_on_next_word_pressed)

	reward_dialog.play_again_pressed.connect(_on_play_again)
	reward_dialog.return_to_map_pressed.connect(_on_return_to_map)

	_load_data()
	_start_game()

func _load_data() -> void:
	word_items = DataManager.get_words_data("words_artikulasyon")
	if word_items.is_empty():
		word_items = [
			{"id": "araba", "word": "Araba", "image": "res://assets/objects/araba.svg", "audio_word": "res://assets/audio/voice/kelime_araba.wav"},
			{"id": "armut", "word": "Armut", "image": "res://assets/objects/armut.svg", "audio_word": "res://assets/audio/voice/kelime_armut.wav"},
			{"id": "balik", "word": "Balık", "image": "res://assets/objects/balik.svg", "audio_word": "res://assets/audio/voice/kelime_balik.wav"},
			{"id": "elma", "word": "Elma", "image": "res://assets/objects/elma.svg", "audio_word": "res://assets/audio/voice/kelime_elma.wav"}
		]

func _start_game() -> void:
	current_index = 0
	word_items.shuffle()
	_setup_round()

func _setup_round() -> void:
	if current_index >= total_rounds or current_index >= word_items.size():
		_finish_game()
		return

	current_target = word_items[current_index]
	var w_text = current_target.get("word", "")
	word_label.text = w_text
	prompt_label.text = "Piko'yu dinle: \"%s\"" % w_text
	status_label.text = "Piko kelimeyi söylüyor, dikkatlice dinle!"

	var img_path = current_target.get("image", "")
	if ResourceLoader.exists(img_path):
		word_image.texture = load(img_path)

	_animate_piko()
	get_tree().create_timer(0.3).timeout.connect(_play_target_word)

func _play_target_word() -> void:
	AudioManager.play_tap_sound()
	var audio_path = current_target.get("audio_word", "")
	if audio_path != "":
		_animate_piko()
		AudioManager.play_voice(audio_path, func():
			status_label.text = "Şimdi sıra sende! Yüksek sesle tekrar et."
		)

func _on_listen_again_pressed() -> void:
	_play_target_word()

func _on_repeat_out_loud_pressed() -> void:
	AudioManager.play_tap_sound()
	_animate_piko()
	status_label.text = "Harika söylüyorsun! Bravo sana!"
	if success_overlay:
		success_overlay.popup_success("Aferin! 🦜")
	AudioManager.play_voice("res://assets/audio/voice/harika.wav", func():
		AudioManager.play_voice("res://assets/audio/voice/aferin.wav")
	)

func _on_next_word_pressed() -> void:
	AudioManager.play_tap_sound()
	GameManager.add_stars(1, "papagani_konustur")
	AudioManager.play_star_sound()
	current_index += 1
	_setup_round()

func _animate_piko() -> void:
	piko_rect.pivot_offset = piko_rect.size / 2.0
	var tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(piko_rect, "scale", Vector2(1.15, 1.15), 0.2)
	tw.tween_property(piko_rect, "scale", Vector2.ONE, 0.25)

func _finish_game() -> void:
	reward_dialog.show_reward(3, "Bütün kelimeleri neşeyle tekrar ettin!")

func _on_play_again() -> void:
	_start_game()

func _on_return_to_map() -> void:
	GameManager.go_to_island_map()

func _on_home_pressed() -> void:
	GameManager.go_to_island_map()
