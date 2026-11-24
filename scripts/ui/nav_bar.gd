extends Control
class_name NavBar

## NavBar
## Bütün ekranlarda tutarlı gezinme, başlık, yıldız sayacı ve ses yardım butonu.

signal home_requested
signal repeat_voice_requested

@onready var title_label: Label = $Margin/HBox/TitleContainer/TitleLabel
@onready var stars_label: Label = $Margin/HBox/StarContainer/StarsLabel
@onready var home_button: TextureButton = $Margin/HBox/HomeButton
@onready var repeat_button: TextureButton = $Margin/HBox/RepeatButton

func _ready() -> void:
	home_button.pressed.connect(_on_home_pressed)
	repeat_button.pressed.connect(_on_repeat_pressed)
	
	if GameManager:
		GameManager.stars_updated.connect(_on_stars_updated)
		update_stars(GameManager.total_stars)

func set_title(new_title: String) -> void:
	if title_label:
		title_label.text = new_title

func set_repeat_button_visible(visible_state: bool) -> void:
	if repeat_button:
		repeat_button.visible = visible_state

func update_stars(count: int) -> void:
	if stars_label:
		stars_label.text = str(count)

func _on_stars_updated(total: int, _added: int) -> void:
	update_stars(total)
	# Minik yıldız titreşim animasyonu
	var star_icon = $Margin/HBox/StarContainer/StarIcon
	if star_icon:
		var tw = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tw.tween_property(star_icon, "scale", Vector2(1.3, 1.3), 0.15)
		tw.tween_property(star_icon, "scale", Vector2.ONE, 0.25)

func _on_home_pressed() -> void:
	AudioManager.play_tap_sound()
	home_requested.emit()
	if not home_requested.get_connections():
		GameManager.go_to_island_map()

func _on_repeat_pressed() -> void:
	AudioManager.play_tap_sound()
	repeat_voice_requested.emit()
