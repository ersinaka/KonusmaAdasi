extends PanelContainer

## PictureCard
## Çocuklar için büyük, dokunması kolay, pastel çerçeveli nesne/kelime kartı.

signal card_clicked(item_id: String)

@onready var texture_rect: TextureRect = $Margin/VBox/TextureRect
@onready var label: Label = $Margin/VBox/Label
@onready var button: Button = $ClickButton

var item_id: String = ""
var is_active: bool = true
var tween: Tween

func _ready() -> void:
	pivot_offset = size / 2.0
	resized.connect(func(): pivot_offset = size / 2.0)
	button.pressed.connect(_on_pressed)

func setup(id: String, image_path: String, word_text: String, show_label: bool = true) -> void:
	item_id = id
	if ResourceLoader.exists(image_path):
		texture_rect.texture = load(image_path)
	label.text = word_text
	label.visible = show_label
	is_active = true
	modulate = Color.WHITE
	scale = Vector2.ONE

func set_interactive(active: bool) -> void:
	is_active = active
	button.disabled = not active

func _on_pressed() -> void:
	if not is_active:
		return
	AudioManager.play_tap_sound()
	card_clicked.emit(item_id)

func play_correct_animation() -> void:
	set_interactive(false)
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25)
	
	# Hafif altın ışıltı tonu
	var color_tw = create_tween()
	color_tw.tween_property(self, "modulate", Color(1.1, 1.1, 0.9, 1.0), 0.2)
	color_tw.tween_property(self, "modulate", Color.WHITE, 0.25)

func play_try_again_animation() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	# Korkutmayan, yumuşak iki yana salınım
	var orig_x = position.x
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:x", orig_x - 10.0, 0.08)
	tween.tween_property(self, "position:x", orig_x + 10.0, 0.08)
	tween.tween_property(self, "position:x", orig_x - 6.0, 0.08)
	tween.tween_property(self, "position:x", orig_x + 6.0, 0.08)
	tween.tween_property(self, "position:x", orig_x, 0.08)
