extends Control
class_name RewardDialog

## RewardDialog
## Çocuklara yönelik pozitif ve teşvik edici ödül penceresi.

signal play_again_pressed
signal return_to_map_pressed

@onready var panel: PanelContainer = $CenterContainer/Panel
@onready var title_label: Label = $CenterContainer/Panel/VBox/TitleLabel
@onready var message_label: Label = $CenterContainer/Panel/VBox/MessageLabel
@onready var stars_container: HBoxContainer = $CenterContainer/Panel/VBox/StarsContainer
@onready var play_again_btn: Button = $CenterContainer/Panel/VBox/Buttons/PlayAgainButton
@onready var continue_btn: Button = $CenterContainer/Panel/VBox/Buttons/ContinueButton

func _ready() -> void:
	visible = false
	play_again_btn.pressed.connect(_on_play_again)
	continue_btn.pressed.connect(_on_continue)

func show_reward(stars_earned: int = 3, custom_message: String = "Harika bir iş çıkardın!") -> void:
	visible = true
	message_label.text = custom_message
	panel.scale = Vector2(0.5, 0.5)
	panel.pivot_offset = panel.size / 2.0
	
	# Tatlı yaylanma animasyonu
	var tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(panel, "scale", Vector2.ONE, 0.35)
	
	# Yıldızları sırayla parlat
	for i in range(stars_container.get_child_count()):
		var star = stars_container.get_child(i)
		star.modulate = Color(1, 1, 1, 0.2)
		star.scale = Vector2(0.3, 0.3)
	
	for i in range(mini(stars_earned, stars_container.get_child_count())):
		var star = stars_container.get_child(i)
		get_tree().create_timer(0.25 + i * 0.2).timeout.connect(func():
			star.modulate = Color.WHITE
			AudioManager.play_star_sound()
			var stw = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			stw.tween_property(star, "scale", Vector2.ONE, 0.4)
		)

	# Teşvik edici seslendirme
	AudioManager.play_voice("res://assets/audio/voice/harika.wav")
	AudioManager.play_success_jingle()

func _on_play_again() -> void:
	AudioManager.play_tap_sound()
	visible = false
	play_again_pressed.emit()

func _on_continue() -> void:
	AudioManager.play_tap_sound()
	visible = false
	return_to_map_pressed.emit()
	if not return_to_map_pressed.get_connections():
		GameManager.go_to_island_map()
