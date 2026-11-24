extends Control

## KayipEsyalar (Mini-Game 4)
## Kelime Köyü - Renk, kategori ve isim eşleme ile kayıp eşyaları bulma oyunu.

const CARD_SCENE = preload("res://scenes/ui/picture_card.tscn")

@onready var nav_bar: Control = $NavBar
@onready var mascot_rect: TextureRect = $TopSection/MascotRect
@onready var prompt_label: Label = $TopSection/PromptBubble/Margin/HBox/PromptLabel
@onready var repeat_audio_btn: TextureButton = $TopSection/PromptBubble/Margin/HBox/SpeakerBtn
@onready var items_grid: GridContainer = $CenterContent/ItemsGrid
@onready var reward_dialog: Control = $RewardDialog

var all_items: Array = []
var current_index: int = 0
var total_rounds: int = 4
var current_target: Dictionary = {}
var is_processing: bool = false
var active_cards: Array = []

func _ready() -> void:
	nav_bar.set_title("Kayıp Eşyalar 🔍")
	nav_bar.home_requested.connect(_on_home_pressed)
	nav_bar.repeat_voice_requested.connect(_repeat_prompt)
	repeat_audio_btn.pressed.connect(_repeat_prompt)

	reward_dialog.play_again_pressed.connect(_on_play_again)
	reward_dialog.return_to_map_pressed.connect(_on_return_to_map)

	_load_items()
	_start_game()

func _load_items() -> void:
	all_items = DataManager.get_words_data("words_esya")
	if all_items.is_empty():
		all_items = [
			{"id": "araba", "name": "Kırmızı Araba", "color": "kırmızı", "category": "taşıt", "image": "res://assets/objects/araba.svg", "audio": "res://assets/audio/voice/kelime_araba.wav"},
			{"id": "armut", "name": "Yeşil Armut", "color": "yeşil", "category": "meyve", "image": "res://assets/objects/armut.svg", "audio": "res://assets/audio/voice/kelime_armut.wav"},
			{"id": "elma", "name": "Kırmızı Elma", "color": "kırmızı", "category": "meyve", "image": "res://assets/objects/elma.svg", "audio": "res://assets/audio/voice/kelime_elma.wav"},
			{"id": "muz", "name": "Sarı Muz", "color": "sarı", "category": "meyve", "image": "res://assets/objects/muz.svg", "audio": "res://assets/audio/voice/kelime_muz.wav"},
			{"id": "top", "name": "Renkli Top", "color": "mavi", "category": "oyuncak", "image": "res://assets/objects/top.svg", "audio": "res://assets/audio/voice/kelime_top.wav"},
			{"id": "kedi", "name": "Tatlı Kedi", "color": "turuncu", "category": "hayvan", "image": "res://assets/objects/kedi.svg", "audio": "res://assets/audio/voice/kelime_kedi.wav"}
		]

func _start_game() -> void:
	current_index = 0
	all_items.shuffle()
	_setup_round()

func _setup_round() -> void:
	if current_index >= total_rounds or current_index >= all_items.size():
		_finish_game()
		return

	is_processing = false
	current_target = all_items[current_index]

	# Dinamik soru oluşturma (kategori/renk ipucu ile)
	var q_text = "Nerede bu %s?" % current_target.get("name", "")
	if current_index % 2 == 1:
		q_text = "%s kategorisindeki %s'yı bulalım!" % [current_target.get("category", "nesne").capitalize(), current_target.get("name", "")]

	prompt_label.text = q_text
	_repeat_prompt()
	_setup_grid_cards()

func _setup_grid_cards() -> void:
	for child in items_grid.get_children():
		child.queue_free()
	active_cards.clear()

	var is_younger = (GameManager.current_age_group == GameManager.AgeGroup.AGE_2_4)
	var card_count = 3 if is_younger else 6

	var choices: Array = [current_target]
	var others = all_items.duplicate()
	others.shuffle()

	for item in others:
		if choices.size() >= card_count:
			break
		if item.get("id") != current_target.get("id"):
			choices.append(item)

	choices.shuffle()

	for i in range(choices.size()):
		var item = choices[i]
		var card = CARD_SCENE.instantiate()
		items_grid.add_child(card)
		active_cards.append(card)

		# Küçük yaşlar için resim öncelikli
		card.setup(item.get("id", ""), item.get("image", ""), item.get("name", ""), not is_younger)
		card.card_clicked.connect(func(clicked_id): _on_item_clicked(item, card))

		# Giriş animasyonu
		card.scale = Vector2(0.6, 0.6)
		card.modulate.a = 0.0
		var tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.set_parallel(true)
		tw.tween_property(card, "scale", Vector2.ONE, 0.3).set_delay(i * 0.07)
		tw.tween_property(card, "modulate:a", 1.0, 0.25).set_delay(i * 0.07)

func _on_item_clicked(clicked_item: Dictionary, card_node: Control) -> void:
	if is_processing:
		return

	if clicked_item.get("id") == current_target.get("id"):
		# DOĞRU EŞYA
		is_processing = true
		card_node.play_correct_animation()
		AudioManager.play_gentle_bell()

		var audio_path = clicked_item.get("audio", "")
		AudioManager.play_voice(audio_path, func():
			AudioManager.play_voice("res://assets/audio/voice/cok_guzel.wav")
		)

		GameManager.add_stars(1, "kayip_esyalar")

		get_tree().create_timer(1.8).timeout.connect(func():
			current_index += 1
			_setup_round()
		)
	else:
		# YANLIŞ EŞYA: Çocuğu bilgilendir ve sevecen yönlendir
		card_node.play_try_again_animation()
		AudioManager.play_tap_sound()
		# Tıklanan eşyanın adını söyleyip doğrusunu hatırlat
		var clicked_name = clicked_item.get("name", "")
		prompt_label.text = "Bu bir %s. Haydi %s'yı bulalım!" % [clicked_name, current_target.get("name", "")]

func _repeat_prompt() -> void:
	var audio_path = current_target.get("audio", "")
	if audio_path != "":
		AudioManager.play_voice(audio_path)

func _finish_game() -> void:
	reward_dialog.show_reward(3, "Bütün kayıp eşyaları sevgiyle buldun!")

func _on_play_again() -> void:
	_start_game()

func _on_return_to_map() -> void:
	GameManager.go_to_island_map()

func _on_home_pressed() -> void:
	GameManager.go_to_island_map()
