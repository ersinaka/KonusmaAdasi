extends Control

## MainMenu
## Konuşma Adası karşılama, yaş grubu seçimi ve ada macerasına başlangıç ekranı.

@onready var fino_mascot: TextureRect = $Content/MascotContainer/FinoMascot
@onready var play_button: Button = $Content/VBox/PlayButton
@onready var age_2_4_btn: Button = $Content/VBox/AgeContainer/Age24Button
@onready var age_5_8_btn: Button = $Content/VBox/AgeContainer/Age58Button
@onready var stars_label: Label = $TopBar/StarContainer/StarsLabel
@onready var info_dialog: Control = $InfoDialog
@onready var info_button: Button = $TopBar/InfoButton
@onready var close_info_btn: Button = $InfoDialog/CenterContainer/Panel/VBox/CloseButton
@onready var voice_hint_btn: TextureButton = $Content/VBox/VoiceHintButton

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	age_2_4_btn.pressed.connect(func(): _set_age_mode(GameManager.AgeGroup.AGE_2_4))
	age_5_8_btn.pressed.connect(func(): _set_age_mode(GameManager.AgeGroup.AGE_5_8))
	info_button.pressed.connect(_on_info_pressed)
	close_info_btn.pressed.connect(_on_close_info_pressed)
	voice_hint_btn.pressed.connect(_on_voice_hint_pressed)

	_update_age_buttons_ui()
	_update_stars_ui()
	_start_mascot_idle_animation()

	# Karşılama sesini çal
	get_tree().create_timer(0.4).timeout.connect(func():
		AudioManager.play_voice("res://assets/audio/voice/fino_ada_rehberi.wav")
	)

func _start_mascot_idle_animation() -> void:
	if not fino_mascot:
		return
	fino_mascot.pivot_offset = fino_mascot.size / 2.0
	var tw = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(fino_mascot, "position:y", fino_mascot.position.y - 12.0, 1.4)
	tw.tween_property(fino_mascot, "position:y", fino_mascot.position.y, 1.4)

func _set_age_mode(group: int) -> void:
	AudioManager.play_tap_sound()
	GameManager.set_age_group(group)
	_update_age_buttons_ui()

func _update_age_buttons_ui() -> void:
	var is_2_4 = (GameManager.current_age_group == GameManager.AgeGroup.AGE_2_4)
	age_2_4_btn.modulate = Color(1.0, 1.0, 1.0, 1.0) if is_2_4 else Color(0.7, 0.7, 0.7, 0.8)
	age_5_8_btn.modulate = Color(1.0, 1.0, 1.0, 1.0) if not is_2_4 else Color(0.7, 0.7, 0.7, 0.8)

func _update_stars_ui() -> void:
	stars_label.text = str(GameManager.total_stars)

func _on_play_pressed() -> void:
	AudioManager.play_tap_sound()
	AudioManager.play_success_jingle()
	GameManager.go_to_island_map()

func _on_voice_hint_pressed() -> void:
	AudioManager.play_tap_sound()
	AudioManager.play_voice("res://assets/audio/voice/fino_ada_rehberi.wav")

func _on_info_pressed() -> void:
	AudioManager.play_tap_sound()
	info_dialog.visible = true

func _on_close_info_pressed() -> void:
	AudioManager.play_tap_sound()
	info_dialog.visible = false
