extends Control

## HikayeyiKurtar (Mini-Game 5)
## Hikâye Kalesi - Olay sıralama, neden-sonuç ve hikâye dinleme/takip oyunu.
## Not: Oyun içi ses kaydı kaldırılmıştır; doğru sıralamadan sonra masalın tamamı seslendirilir.

const CARD_SCENE = preload("res://scenes/ui/picture_card.tscn")

@onready var nav_bar: Control = $NavBar
@onready var fino_rect: TextureRect = $TopSection/FinoRect
@onready var prompt_label: Label = $TopSection/PromptBubble/Margin/HBox/PromptLabel
@onready var repeat_audio_btn: TextureButton = $TopSection/PromptBubble/Margin/HBox/SpeakerBtn

@onready var slots_container: HBoxContainer = $StoryBoard/SlotsContainer
@onready var card_pool_container: HBoxContainer = $StoryBoard/CardPoolContainer
@onready var reset_button: Button = $StoryBoard/ResetButton

# Hikaye tamamlama paneli
@onready var storytelling_panel: PanelContainer = $StorytellingPanel
@onready var listen_story_btn: Button = $StorytellingPanel/VBox/Controls/ListenStoryBtn
@onready var next_story_btn: Button = $StorytellingPanel/VBox/Controls/NextStoryBtn

@onready var reward_dialog: Control = $RewardDialog
@onready var success_overlay: Control = $SuccessOverlay

var stories_data: Array = []
var current_story_index: int = 0
var current_story: Dictionary = {}
var expected_cards: Array = []
var placed_cards: Array = []
var is_sequence_complete: bool = false

func _ready() -> void:
	nav_bar.set_title("Hikâyeyi Kurtar 🏰")
	nav_bar.home_requested.connect(_on_home_pressed)
	nav_bar.repeat_voice_requested.connect(_repeat_story_prompt)
	repeat_audio_btn.pressed.connect(_repeat_story_prompt)
	reset_button.pressed.connect(_on_reset_pressed)

	listen_story_btn.pressed.connect(_on_listen_story_pressed)
	next_story_btn.pressed.connect(_on_next_story_pressed)

	reward_dialog.play_again_pressed.connect(_on_play_again)
	reward_dialog.return_to_map_pressed.connect(_on_return_to_map)

	_load_stories()
	_start_game()

func _load_stories() -> void:
	stories_data = DataManager.get_activities_data("stories")
	if stories_data.is_empty():
		stories_data = [
			{
				"id": "tohum_ve_cicek",
				"title": "Tohumun Çiçek Açması",
				"prompt": "Çiçeğin büyüme hikayesini sıraya diz!",
				"cards": [
					{"order": 1, "title": "1. Tohum Ekme", "description": "Toprağa tohum ekildi.", "image": "res://assets/objects/elma.svg"},
					{"order": 2, "title": "2. Güneş ve Su", "description": "Güneş açtı ve sulandı.", "image": "res://assets/objects/gunes.svg"},
					{"order": 3, "title": "3. Güzel Çiçek", "description": "Rengarenk çiçek açtı!", "image": "res://assets/objects/cicek.svg"}
				]
			}
		]

func _start_game() -> void:
	current_story_index = 0
	_setup_round()

func _setup_round() -> void:
	if current_story_index >= stories_data.size():
		_finish_game()
		return

	is_sequence_complete = false
	placed_cards.clear()
	storytelling_panel.visible = false

	current_story = stories_data[current_story_index]
	expected_cards = current_story.get("cards", [])
	
	prompt_label.text = "%s: %s" % [current_story.get("title", ""), current_story.get("prompt", "")]
	_repeat_story_prompt()

	_setup_slots()
	_setup_pool()
	_animate_fino()

func _setup_slots() -> void:
	for child in slots_container.get_children():
		child.queue_free()

	for i in range(expected_cards.size()):
		var slot = PanelContainer.new()
		slot.custom_minimum_size = Vector2(210, 230)
		slot.name = "Slot_%d" % i

		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER

		var num_label = Label.new()
		num_label.text = "%d. Adım" % (i + 1)
		num_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		num_label.add_theme_font_size_override("font_size", 22)
		num_label.add_theme_color_override("font_color", Color(0.4, 0.45, 0.5, 0.8))
		vbox.add_child(num_label)

		var slot_holder = CenterContainer.new()
		slot_holder.name = "SlotHolder"
		slot_holder.custom_minimum_size = Vector2(180, 160)
		vbox.add_child(slot_holder)

		slot.add_child(vbox)
		slots_container.add_child(slot)

func _setup_pool() -> void:
	for child in card_pool_container.get_children():
		child.queue_free()

	var shuffled = expected_cards.duplicate()
	shuffled.shuffle()

	for card_data in shuffled:
		var card = CARD_SCENE.instantiate()
		card_pool_container.add_child(card)
		card.setup(str(card_data.get("order", 1)), card_data.get("image", ""), card_data.get("title", ""), true)
		card.card_clicked.connect(func(_clicked_id): _on_pool_card_clicked(card_data, card))

func _on_pool_card_clicked(card_data: Dictionary, card_node: Control) -> void:
	if is_sequence_complete:
		return

	var current_step = placed_cards.size() + 1
	var target_order = card_data.get("order", 1)

	if target_order == current_step:
		# DOĞRU SIRALAMA
		placed_cards.append(card_data)
		card_node.visible = false
		if success_overlay:
			success_overlay.popup_success("Doğru Adım! ⭐")

		var slot = slots_container.get_child(current_step - 1)
		var holder = slot.find_child("SlotHolder", true, false)
		if holder:
			var docked_card = CARD_SCENE.instantiate()
			holder.add_child(docked_card)
			docked_card.setup(str(target_order), card_data.get("image", ""), card_data.get("title", ""), true)
			docked_card.set_interactive(false)
			docked_card.play_correct_animation()

		if placed_cards.size() == expected_cards.size():
			_on_story_completed()
	else:
		# YANLIŞ SIRA: Yumuşak uyarı
		card_node.play_try_again_animation()
		AudioManager.play_tap_sound()
		prompt_label.text = "İlk önce ne olmuş olabilir? Haydi birlikte düşünelim!"

func _on_story_completed() -> void:
	is_sequence_complete = true
	AudioManager.play_success_jingle()
	AudioManager.play_voice("res://assets/audio/voice/harika.wav")
	GameManager.add_stars(1, "hikayeyi_kurtar")

	prompt_label.text = "Tebrikler! Masalı harika bir sıraya dizdin. Şimdi masalı dinleyebilirsin!"
	storytelling_panel.visible = true

func _on_listen_story_pressed() -> void:
	AudioManager.play_tap_sound()
	_animate_fino()
	AudioManager.play_voice("res://assets/audio/voice/cok_guzel.wav")

func _on_next_story_pressed() -> void:
	AudioManager.play_tap_sound()
	current_story_index += 1
	_setup_round()

func _on_reset_pressed() -> void:
	if is_sequence_complete:
		return
	AudioManager.play_tap_sound()
	placed_cards.clear()
	_setup_slots()
	_setup_pool()

func _repeat_story_prompt() -> void:
	AudioManager.play_voice("res://assets/audio/voice/fino_ada_rehberi.wav")

func _animate_fino() -> void:
	fino_rect.pivot_offset = fino_rect.size / 2.0
	var tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(fino_rect, "position:y", fino_rect.position.y - 8.0, 0.3)
	tw.tween_property(fino_rect, "position:y", fino_rect.position.y, 0.3)

func _finish_game() -> void:
	reward_dialog.show_reward(3, "Bütün masalları başarıyla tamamladın!")

func _on_play_again() -> void:
	_start_game()

func _on_return_to_map() -> void:
	GameManager.go_to_island_map()

func _on_home_pressed() -> void:
	GameManager.go_to_island_map()
