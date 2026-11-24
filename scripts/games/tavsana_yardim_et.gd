extends Control

## TavsanaYardimEt (Mini-Game 1)
## Ses Ormanı - Tavşan Mimi ile hedef ses ve kelime bulma oyunu.

const CARD_SCENE = preload("res://scenes/ui/picture_card.tscn")

@onready var nav_bar: Control = $NavBar
@onready var mimi_rect: TextureRect = $MascotContainer/MimiRect
@onready var prompt_bubble: PanelContainer = $MascotContainer/PromptBubble
@onready var prompt_label: Label = $MascotContainer/PromptBubble/Margin/HBox/PromptLabel
@onready var prompt_speaker_btn: TextureButton = $MascotContainer/PromptBubble/Margin/HBox/SpeakerBtn
@onready var cards_container: HBoxContainer = $CardsContainer
@onready var reward_dialog: Control = $RewardDialog
@onready var success_overlay: Control = $SuccessOverlay

var word_items: Array = []
var current_round_index: int = 0
var total_rounds: int = 4
var current_target_item: Dictionary = {}
var is_processing_input: bool = false
var active_cards: Array = []

func _ready() -> void:
	nav_bar.set_title("Tavşana Yardım Et 🌸")
	nav_bar.home_requested.connect(_on_home_pressed)
	nav_bar.repeat_voice_requested.connect(_repeat_prompt_audio)
	prompt_speaker_btn.pressed.connect(_repeat_prompt_audio)
	reward_dialog.play_again_pressed.connect(_on_play_again)
	reward_dialog.return_to_map_pressed.connect(_on_return_to_map)

	_load_words()
	_start_game()

func _load_words() -> void:
	word_items = DataManager.get_words_data("words_artikulasyon")
	if word_items.is_empty():
		# Güvenlik yedeği
		word_items = [
			{
				"id": "araba",
				"word": "Araba",
				"image": "res://assets/objects/araba.svg",
				"audio_word": "res://assets/audio/voice/kelime_araba.wav",
				"audio_prompt": "res://assets/audio/voice/mimi_araba_sorusu.wav",
				"question_text": "Hangisi araba?",
				"distractors": ["armut", "balik"]
			},
			{
				"id": "armut",
				"word": "Armut",
				"image": "res://assets/objects/armut.svg",
				"audio_word": "res://assets/audio/voice/kelime_armut.wav",
				"audio_prompt": "res://assets/audio/voice/mimi_armut_sorusu.wav",
				"question_text": "Hangisi armut?",
				"distractors": ["araba", "elma"]
			}
		]

func _start_game() -> void:
	current_round_index = 0
	word_items.shuffle()
	_start_round()

func _start_round() -> void:
	if current_round_index >= total_rounds or current_round_index >= word_items.size():
		_finish_game()
		return

	is_processing_input = false
	current_target_item = word_items[current_round_index]
	
	# Mimi konuşma balonu
	var q_text = current_target_item.get("question_text", "Hangisi %s?" % current_target_item.get("word", ""))
	prompt_label.text = q_text
	_animate_mimi_talk()

	# Sesli yönergeyi çal
	_repeat_prompt_audio()

	# Seçenek kartlarını hazırla
	_setup_cards()

func _setup_cards() -> void:
	# Önceki kartları temizle
	for child in cards_container.get_children():
		child.queue_free()
	active_cards.clear()

	var is_younger = (GameManager.current_age_group == GameManager.AgeGroup.AGE_2_4)
	var card_count = 2 if is_younger else 3 # 2-4 yaş için 2 kart, 5-8 yaş için 3 kart

	var choices: Array = [current_target_item]
	var distractors: Array = current_target_item.get("distractors", []).duplicate()
	distractors.shuffle()

	for d_id in distractors:
		if choices.size() >= card_count:
			break
		# Id'ye karşılık gelen nesneyi bul
		for item in word_items:
			if item.get("id") == d_id and not choices.has(item):
				choices.append(item)
				break

	# Eğer eksik kalırsa diğerlerinden tamamla
	if choices.size() < card_count:
		for item in word_items:
			if not choices.has(item):
				choices.append(item)
				if choices.size() >= card_count:
					break

	choices.shuffle()

	# Kartları sahneye ekle
	for i in range(choices.size()):
		var item = choices[i]
		var card = CARD_SCENE.instantiate()
		cards_container.add_child(card)
		active_cards.append(card)
		
		var show_text = not is_younger # Küçük yaşlarda sadece resim, büyüklerde yazı da görünür
		card.setup(item.get("id", ""), item.get("image", ""), item.get("word", ""), show_text)
		card.card_clicked.connect(_on_card_clicked)

		# Giriş animasyonu
		card.scale = Vector2(0.5, 0.5)
		card.modulate.a = 0.0
		var tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.set_parallel(true)
		tw.tween_property(card, "scale", Vector2.ONE, 0.35).set_delay(i * 0.1)
		tw.tween_property(card, "modulate:a", 1.0, 0.3).set_delay(i * 0.1)

func _on_card_clicked(clicked_id: String) -> void:
	if is_processing_input:
		return

	var target_id = current_target_item.get("id", "")
	var target_card: Control = null
	for card in active_cards:
		if card.item_id == clicked_id:
			target_card = card
			break

	if clicked_id == target_id:
		# DOĞRU CEVAP
		is_processing_input = true
		if target_card:
			target_card.play_correct_animation()
		
		# Otizmli çocuklar için belirgin yeşil tick ve tatlı bong sesi
		if success_overlay:
			success_overlay.popup_success("Aferin! ⭐")
		
		_mimi_celebrate()
		
		# Kelime telaffuzu ve ardından övgü sesi
		var word_audio = current_target_item.get("audio_word", "")
		AudioManager.play_voice(word_audio, func():
			AudioManager.play_voice("res://assets/audio/voice/aferin.wav")
		)

		GameManager.add_stars(1, "tavsana_yardim_et")

		# Sonraki tura yumuşak geçiş
		get_tree().create_timer(1.8).timeout.connect(func():
			current_round_index += 1
			_start_round()
		)
	else:
		# YANLIŞ CEVAP - Asla cezalandırma yok, nazikçe yeniden deneme
		if target_card:
			target_card.play_try_again_animation()
		AudioManager.play_tap_sound()
		# Mimi sevecen bir ses tonuyla hedefi hatırlatır
		prompt_label.text = "Haydi tekrar dene! Hangisi %s?" % current_target_item.get("word", "")
		_repeat_prompt_audio()

func _repeat_prompt_audio() -> void:
	var prompt_audio = current_target_item.get("audio_prompt", "")
	if prompt_audio != "":
		AudioManager.play_voice(prompt_audio)

func _animate_mimi_talk() -> void:
	mimi_rect.pivot_offset = mimi_rect.size / 2.0
	var tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(mimi_rect, "position:y", mimi_rect.position.y - 10.0, 0.25)
	tw.tween_property(mimi_rect, "position:y", mimi_rect.position.y, 0.25)

func _mimi_celebrate() -> void:
	var tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(mimi_rect, "scale", Vector2(1.2, 1.2), 0.2)
	tw.tween_property(mimi_rect, "scale", Vector2.ONE, 0.3)

func _finish_game() -> void:
	reward_dialog.show_reward(3, "Bütün kelimeleri başarıyla buldun!")

func _on_play_again() -> void:
	_start_game()

func _on_return_to_map() -> void:
	GameManager.go_to_island_map()

func _on_home_pressed() -> void:
	GameManager.go_to_island_map()
