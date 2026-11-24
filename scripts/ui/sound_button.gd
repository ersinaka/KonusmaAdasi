extends TextureButton
class_name SoundButton

## Reusable SoundButton
## Çocuklar için dokunma hissi yüksek, yumuşak yaylanmalı (squash/stretch) buton.

@export var click_sound: AudioStream = null
@export var voice_prompt: AudioStream = null
@export var normal_scale: Vector2 = Vector2.ONE
@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var press_scale: Vector2 = Vector2(0.92, 0.92)

var tween: Tween

func _ready() -> void:
	pivot_offset = size / 2.0
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	pressed.connect(_on_pressed)
	resized.connect(_on_resized)

func _on_resized() -> void:
	pivot_offset = size / 2.0

func _on_mouse_entered() -> void:
	_animate_scale(hover_scale, 0.15)

func _on_mouse_exited() -> void:
	_animate_scale(normal_scale, 0.15)

func _on_button_down() -> void:
	_animate_scale(press_scale, 0.08)

func _on_button_up() -> void:
	_animate_scale(hover_scale, 0.12)

func _on_pressed() -> void:
	if click_sound:
		AudioManager.play_sfx(click_sound)
	else:
		AudioManager.play_tap_sound()

	if voice_prompt:
		AudioManager.play_voice(voice_prompt)

func _animate_scale(target_scale: Vector2, duration: float) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target_scale, duration)
