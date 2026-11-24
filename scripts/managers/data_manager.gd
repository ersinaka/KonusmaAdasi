extends Node

## DataManager
## JSON tabanlı kelime, etkinlik ve yerel oyuncu verisi yöneticisi.

const SAVE_FILE_PATH: String = "user://konusma_adasi_save.json"

var player_data: Dictionary = {
	"total_stars": 0,
	"age_group": 0,
	"completed_activities": {},
	"settings": {
		"voice_volume": 1.0,
		"sfx_volume": 1.0,
		"music_volume": 0.7,
		"audio_hints_enabled": true
	}
}

var words_cache: Dictionary = {}
var activities_cache: Dictionary = {}

func _ready() -> void:
	load_player_data()
	_preload_game_data()

func _preload_game_data() -> void:
	# Sözlük ve etkinlik verilerini önceden yükle
	var word_files = [
		"res://data/words/words_artikulasyon.json",
		"res://data/words/words_hece.json",
		"res://data/words/words_esya.json"
	]
	for path in word_files:
		var data = load_json_file(path)
		if not data.is_empty():
			var file_key = path.get_file().get_basename()
			words_cache[file_key] = data

	var activity_files = [
		"res://data/activities/stories.json"
	]
	for path in activity_files:
		var data = load_json_file(path)
		if not data.is_empty():
			var file_key = path.get_file().get_basename()
			activities_cache[file_key] = data

func load_json_file(file_path: String) -> Variant:
	if not FileAccess.file_exists(file_path):
		push_warning("JSON dosyası bulunamadı: %s" % file_path)
		return {}

	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("JSON dosyası açılamadı: %s (Hata: %d)" % [file_path, FileAccess.get_open_error()])
		return {}

	var text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(text)
	if error != OK:
		push_error("JSON ayrıştırma hatası (%s): Satır %d - %s" % [file_path, json.get_error_line(), json.get_error_message()])
		return {}

	return json.data

func save_json_file(file_path: String, data: Variant) -> bool:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Dosyaya yazılamadı: %s (Hata: %d)" % [file_path, FileAccess.get_open_error()])
		return false

	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	return true

func load_player_data() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var loaded = load_json_file(SAVE_FILE_PATH)
		if loaded is Dictionary and not loaded.is_empty():
			player_data.merge(loaded, true)
			print("Oyuncu verileri başarıyla yüklendi.")
	else:
		save_player_data()

func save_player_data() -> void:
	# GameManager'daki anlık değerleri al
	if GameManager:
		player_data["total_stars"] = GameManager.total_stars
		player_data["age_group"] = GameManager.current_age_group
		player_data["completed_activities"] = GameManager.completed_activities
	
	save_json_file(SAVE_FILE_PATH, player_data)

func get_player_data() -> Dictionary:
	return player_data

func get_words_data(category_key: String) -> Array:
	if words_cache.has(category_key):
		var cat_data = words_cache[category_key]
		if cat_data is Array:
			return cat_data
		elif cat_data is Dictionary and cat_data.has("items"):
			return cat_data["items"]
	return []

func get_activities_data(activity_key: String) -> Array:
	if activities_cache.has(activity_key):
		var act_data = activities_cache[activity_key]
		if act_data is Array:
			return act_data
		elif act_data is Dictionary and act_data.has("stories"):
			return act_data["stories"]
	return []
