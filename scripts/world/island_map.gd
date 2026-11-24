extends Control

## IslandMap
## Ada üzerindeki 4 eğitsel bölgenin seçim haritası.

@onready var nav_bar: Control = $NavBar
@onready var btn_ses_ormani: Button = $MapGrid/SesOrmaniCard/PlayButton
@onready var btn_papagan: Button = $MapGrid/PapaganCard/PlayButton
@onready var btn_hece_denizi: Button = $MapGrid/HeceDeniziCard/PlayButton
@onready var btn_kayip_esyalar: Button = $MapGrid/KayipEsyalarCard/PlayButton
@onready var btn_hikaye_kalesi: Button = $MapGrid/HikayeKalesiCard/PlayButton

func _ready() -> void:
	nav_bar.set_title("Ada Haritası")
	nav_bar.set_repeat_button_visible(false)
	nav_bar.home_requested.connect(_on_home_pressed)

	btn_ses_ormani.pressed.connect(func(): _open_game("res://scenes/games/tavsana_yardim_et.tscn"))
	btn_papagan.pressed.connect(func(): _open_game("res://scenes/games/papagani_konustur.tscn"))
	btn_hece_denizi.pressed.connect(func(): _open_game("res://scenes/games/kelime_treni.tscn"))
	btn_kayip_esyalar.pressed.connect(func(): _open_game("res://scenes/games/kayip_esyalar.tscn"))
	btn_hikaye_kalesi.pressed.connect(func(): _open_game("res://scenes/games/hikayeyi_kurtar.tscn"))

	_animate_cards_in()

func _animate_cards_in() -> void:
	var cards = $MapGrid.get_children()
	for i in range(cards.size()):
		var card = cards[i]
		card.scale = Vector2(0.8, 0.8)
		card.modulate.a = 0.0
		card.pivot_offset = card.size / 2.0
		var tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.set_parallel(true)
		tw.tween_property(card, "scale", Vector2.ONE, 0.4).set_delay(i * 0.08)
		tw.tween_property(card, "modulate:a", 1.0, 0.3).set_delay(i * 0.08)

func _open_game(scene_path: String) -> void:
	AudioManager.play_tap_sound()
	GameManager.change_scene(scene_path)

func _on_home_pressed() -> void:
	GameManager.go_to_main_menu()
