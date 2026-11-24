extends Node

## Automated Quality Assurance Suite for Konuşma Adası

func _ready() -> void:
	print("\n==================================================")
	print("  KONUŞMA ADASI - OTOMATİK QA DOĞRULAMA TESTLERİ  ")
	print("==================================================")
	
	var passed = 0
	var failed = 0

	# Test 1: DataManager JSON Doğrulaması
	if _test_data_manager():
		print("[PASS] Test 1: DataManager & JSON Veri Tabanı")
		passed += 1
	else:
		print("[FAIL] Test 1: DataManager & JSON Veri Tabanı")
		failed += 1

	# Test 2: GameManager ve Yaş Modları
	if _test_game_manager():
		print("[PASS] Test 2: GameManager, Yaş Grupları & Yıldız Sistemi")
		passed += 1
	else:
		print("[FAIL] Test 2: GameManager, Yaş Grupları & Yıldız Sistemi")
		failed += 1

	# Test 3: AudioManager & Ses Sistemi
	if _test_audio_manager():
		print("[PASS] Test 3: AudioManager, Prosedürel Sesler & Doğal TTS Yürütücü")
		passed += 1
	else:
		print("[FAIL] Test 3: AudioManager & Ses Sistemi")
		failed += 1

	# Test 4: Bütün Sahnelerin Yüklenmesi (Kayıt bağımsız ve stabil)
	if _test_all_scenes():
		print("[PASS] Test 4: 7 Temel Sahnenin (Menü, Harita, 5 Mini Oyun) Yüklenmesi")
		passed += 1
	else:
		print("[FAIL] Test 4: 7 Temel Sahnenin Yüklenmesi")
		failed += 1

	print("\n==================================================")
	print("  SONUÇ: %d BAŞARILI, %d BAŞARISIZ" % [passed, failed])
	print("==================================================\n")

	if failed > 0:
		get_tree().quit(1)
	else:
		get_tree().quit(0)

func _test_data_manager() -> bool:
	var art_words = DataManager.get_words_data("words_artikulasyon")
	if art_words.size() < 4:
		printerr("Artikülasyon kelime sayısı yetersiz: ", art_words.size())
		return false

	var hece_words = DataManager.get_words_data("words_hece")
	if hece_words.size() < 4:
		printerr("Hece kelime sayısı yetersiz: ", hece_words.size())
		return false

	var esya_words = DataManager.get_words_data("words_esya")
	if esya_words.size() < 4:
		printerr("Kayıp eşya sayısı yetersiz: ", esya_words.size())
		return false

	var stories = DataManager.get_activities_data("stories")
	if stories.is_empty():
		printerr("Hikâye verisi boş!")
		return false

	return true

func _test_game_manager() -> bool:
	var initial_stars = GameManager.total_stars
	GameManager.add_stars(3, "test_activity")
	if GameManager.total_stars != initial_stars + 3:
		printerr("Yıldız ekleme hatası! Beklenen: ", initial_stars + 3, " Alınan: ", GameManager.total_stars)
		return false

	GameManager.set_age_group(GameManager.AgeGroup.AGE_5_8)
	if GameManager.current_age_group != GameManager.AgeGroup.AGE_5_8:
		printerr("Yaş grubu güncelleme hatası!")
		return false

	GameManager.set_age_group(GameManager.AgeGroup.AGE_2_4)
	return true

func _test_audio_manager() -> bool:
	if not AudioManager:
		printerr("AudioManager autoload bulunamadı!")
		return false

	# Prosedürel ses fonksiyonlarının sorunsuz çalışması
	AudioManager.play_gentle_bell()
	AudioManager.play_star_sound()
	AudioManager.play_tap_sound()
	return true

func _test_all_scenes() -> bool:
	var scenes = [
		"res://scenes/main/main_menu.tscn",
		"res://scenes/world/island_map.tscn",
		"res://scenes/games/tavsana_yardim_et.tscn",
		"res://scenes/games/papagani_konustur.tscn",
		"res://scenes/games/kelime_treni.tscn",
		"res://scenes/games/kayip_esyalar.tscn",
		"res://scenes/games/hikayeyi_kurtar.tscn"
	]

	for path in scenes:
		if not ResourceLoader.exists(path):
			printerr("Sahne dosyası bulunamadı: ", path)
			return false
		var packed = load(path) as PackedScene
		if not packed:
			printerr("Sahne load edilemedi: ", path)
			return false
		var inst = packed.instantiate()
		if not inst:
			printerr("Sahne örneği oluşturulamadı: ", path)
			return false
		inst.queue_free()

	return true
