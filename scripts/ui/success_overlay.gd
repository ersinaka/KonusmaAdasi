extends Control

## SuccessOverlay
## Otizmli ve özel gereksinimli çocuklar için belirgin, dikkat çekici,
## neşeli büyük yeşil onay işareti (tick) ve ince tatlı bong sesi efekti.

@onready var container: CenterContainer = $CenterContainer
@onready var check_icon: TextureRect = $CenterContainer/VBox/CheckIcon
@onready var message_label: Label = $CenterContainer/VBox/MessageLabel

var tween: Tween

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func popup_success(custom_text: String = "Harika! ⭐") -> void:
	visible = true
	message_label.text = custom_text
	
	# İnce tatlı bong sesini çal
	AudioManager.play_sweet_bong()

	if tween and tween.is_running():
		tween.kill()

	container.scale = Vector2(0.2, 0.2)
	container.pivot_offset = container.size / 2.0
	modulate.a = 1.0

	# Elastik ve dikkat çekici yaylanma
	tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(container, "scale", Vector2(1.25, 1.25), 0.35)
	tween.tween_property(container, "scale", Vector2.ONE, 0.25)
	
	# 0.7 saniye bekle ve yumuşakça kaybol
	tween.tween_interval(0.4)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): visible = false)
