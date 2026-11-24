extends Control

## KelimeTreni (Mini-Game 3)
## Hece Denizi - Kaptan Toto ile heceleri vagonlara doğru sırayla dizme oyunu.

@onready var nav_bar: Control = $NavBar
@onready var toto_rect: TextureRect = $TopSection/TotoRect
@onready var prompt_label: Label = $TopSection/PromptBubble/Margin/HBox/PromptLabel
@onready var repeat_audio_btn: TextureButton = $TopSection/PromptBubble/Margin/HBox/SpeakerBtn

@onready var target_word_label: Label = $WordPreview/WordLabel
@onready var target_image: TextureRect = $WordPreview/TargetImage

@onready var train_container: HBoxContainer = $TrainArea/TrainContainer
@onready var locomotive_rect: TextureRect = $TrainArea/TrainContainer/Locomotive
@onready var wagon_slots_container: HBoxContainer = $TrainArea/TrainContainer/WagonSlots
@onready var syllable_pool_container: HBoxContainer = $PoolArea/SyllablePool

@onready var reset_button: Button = $PoolArea/ResetButton
@onready var reward_dialog: Control = $RewardDialog
@onready var success_overlay: Control = $SuccessOverlay

var word_items: Array = []
var current_index: int = 0
var total_rounds: int = 4
var current_item: Dictionary = {}
var expected_syllables: Array = []
var current_placed_syllables: Array = []
var is_round_locked: bool = false

func _ready() -> void:
	nav_bar.set_title("Kelime Treni 🚂")
	nav_bar.home_requested.connect(_on_home_pressed)
	nav_bar.repeat_voice_requested.connect(_play_target_word)
	repeat_audio_btn.pressed.connect(_play_target_word)
	reset_button.pressed.connect(_on_reset_pressed)

	reward_dialog.play_again_pressed.connect(_on_play_again)
	reward_dialog.return_to_map_pressed.connect(_on_return_to_map)

	_load_words()
	_start_game()

func _load_words() -> void:
	word_items = DataManager.get_words_data("words_hece")
	if word_items.is_empty():
		word_items = [
			{
				"id": "araba",
				"word": "Araba",
				"image": "res://assets/objects/araba.svg",
				"audio_word": "res://assets/audio/voice/kelime_araba.wav",
				"syllables": ["A", "RA", "BA"]
			},
			{
				"id": "armut",
				"word": "Armut",
				"image": "res://assets/objects/armut.svg",
				"audio_word": "res://assets/audio/voice/kelime_armut.wav",
				"syllables": ["AR", "MUT"]
			},
			{
				"id": "balik",
				"word": "Balık",
				"image": "res://assets/objects/balik.svg",
				"audio_word": "res://assets/audio/voice/kelime_balik.wav",
				"syllables": ["BA", "LIK"]
			},
			{
				"id": "elma",
				"word": "Elma",
				"image": "res://assets/objects/elma.svg",
				"audio_word": "res://assets/audio/voice/kelime_elma.wav",
				"syllables": ["EL", "MA"]
			}
		]

func _start_game() -> void:
	current_index = 0
	word_items.shuffle()
	_setup_round()

func _setup_round() -> void:
	if current_index >= total_rounds or current_index >= word_items.size():
		_finish_game()
		return

	is_round_locked = false
	current_placed_syllables.clear()
	current_item = word_items[current_index]
	expected_syllables = current_item.get("syllables", [])

	target_word_label.text = current_item.get("word", "")
	prompt_label.text = "Heceleri doğru sırayla trene dizelim: %s" % current_item.get("word", "")
	
	var img_path = current_item.get("image", "")
	if ResourceLoader.exists(img_path):
		target_image.texture = load(img_path)

	_setup_wagons()
	_setup_syllable_pool()
	_play_target_word()
	_animate_toto()

func _play_target_word() -> void:
	AudioManager.play_tap_sound()
	var audio_path = current_item.get("audio_word", "")
	if audio_path != "":
		AudioManager.play_voice(audio_path)

func _setup_wagons() -> void:
	for child in wagon_slots_container.get_children():
		child.queue_free()

	for i in range(expected_syllables.size()):
		var wagon_panel = PanelContainer.new()
		wagon_panel.custom_minimum_size = Vector2(130, 110)
		wagon_panel.name = "WagonSlot_%d" % i

		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER

		var wagon_img = TextureRect.new()
		wagon_img.texture = load("res://assets/objects/tren_vagon.svg")
		wagon_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		wagon_img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		wagon_img.custom_minimum_size = Vector2(110, 60)
		vbox.add_child(wagon_img)

		var slot_label = Label.new()
		slot_label.name = "SlotLabel"
		slot_label.text = "?"
		slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot_label.add_theme_font_size_override("font_size", 24)
		slot_label.add_theme_color_override("font_color", Color(0.3, 0.4, 0.5, 0.6))
		vbox.add_child(slot_label)

		wagon_panel.add_child(vbox)
		wagon_slots_container.add_child(wagon_panel)

func _setup_syllable_pool() -> void:
	for child in syllable_pool_container.get_children():
		child.queue_free()

	var shuffled = expected_syllables.duplicate()
	shuffled.shuffle()

	for syl in shuffled:
		var syl_btn = Button.new()
		syl_btn.custom_minimum_size = Vector2(130, 68)
		syl_btn.text = syl
		syl_btn.add_theme_font_size_override("font_size", 26)
		syl_btn.pressed.connect(func(): _on_syllable_selected(syl, syl_btn))
		syllable_pool_container.add_child(syl_btn)

func _on_syllable_selected(syl: String, btn: Button) -> void:
	if is_round_locked:
		return

	var current_slot_index = current_placed_syllables.size()
	if current_slot_index >= expected_syllables.size():
		return

	var correct_syl = expected_syllables[current_slot_index]

	if syl == correct_syl:
		# DOĞRU HECE
		current_placed_syllables.append(syl)
		btn.visible = false
		if success_overlay:
			success_overlay.popup_success("Harika! 🚂")

		# Vagon kutusuna yerleştir
		var wagon = wagon_slots_container.get_child(current_slot_index)
		var label = wagon.find_child("SlotLabel", true, false) as Label
		if label:
			label.text = syl
			label.add_theme_color_override("font_color", Color(0.1, 0.6, 0.3, 1.0))
			# Yaylanma animasyonu
			var tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tw.tween_property(label, "scale", Vector2(1.3, 1.3), 0.15)
			tw.tween_property(label, "scale", Vector2.ONE, 0.2)

		# Eğer bütün vagonlar dolduysa tren hareket eder!
		if current_placed_syllables.size() == expected_syllables.size():
			_on_word_completed()
	else:
		# Yanlış sıradaki hece: butonu hafifçe salla, teşvik et
		AudioManager.play_tap_sound()
		var orig_x = btn.position.x
		var tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tw.tween_property(btn, "position:x", orig_x - 8.0, 0.08)
		tw.tween_property(btn, "position:x", orig_x + 8.0, 0.08)
		tw.tween_property(btn, "position:x", orig_x, 0.08)
		prompt_label.text = "İlk önce hangi hece gelir? Tekrar düşünelim!"

func _on_word_completed() -> void:
	is_round_locked = true
	AudioManager.play_success_jingle()
	AudioManager.play_voice("res://assets/audio/voice/harika.wav")
	GameManager.add_stars(1, "kelime_treni")

	# Tren neşeyle ileri geri hoplar
	var tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(train_container, "position:x", train_container.position.x + 30.0, 0.4)
	tw.tween_property(train_container, "position:x", train_container.position.x, 0.4)

	prompt_label.text = "Tebrikler! Tren yolculuğa hazır: %s" % current_item.get("word", "")

	get_tree().create_timer(2.0).timeout.connect(func():
		current_index += 1
		_setup_round()
	)

func _on_reset_pressed() -> void:
	if is_round_locked:
		return
	AudioManager.play_tap_sound()
	current_placed_syllables.clear()
	_setup_wagons()
	_setup_syllable_pool()
	prompt_label.text = "Heceleri tekrar dizelim."

func _animate_toto() -> void:
	toto_rect.pivot_offset = toto_rect.size / 2.0
	var tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(toto_rect, "position:y", toto_rect.position.y - 8.0, 0.3)
	tw.tween_property(toto_rect, "position:y", toto_rect.position.y, 0.3)

func _finish_game() -> void:
	reward_dialog.show_reward(3, "Bütün trenleri hecelerle doldurdun!")

func _on_play_again() -> void:
	_start_game()

func _on_return_to_map() -> void:
	GameManager.go_to_island_map()

func _on_home_pressed() -> void:
	GameManager.go_to_island_map()
