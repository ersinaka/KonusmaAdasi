extends Node

## GameManager
## Konuşma Adası genel durum, yaş modu ve sahne navigasyon yöneticisi.

signal age_group_changed(new_group: int)
signal stars_updated(total_stars: int, added: int)
signal scene_transition_started(target_scene: String)
signal scene_transition_completed(target_scene: String)

enum AgeGroup {
	AGE_2_4 = 0,
	AGE_5_8 = 1
}

var current_age_group: int = AgeGroup.AGE_2_4
var total_stars: int = 0
var completed_activities: Dictionary = {}

var is_transitioning: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_saved_progress()

func set_age_group(group: int) -> void:
	if group != current_age_group:
		current_age_group = group
		age_group_changed.emit(current_age_group)
		DataManager.save_player_data()

func add_stars(amount: int, activity_id: String = "") -> void:
	if amount <= 0:
		return
	total_stars += amount
	if activity_id != "":
		completed_activities[activity_id] = completed_activities.get(activity_id, 0) + 1
	stars_updated.emit(total_stars, amount)
	DataManager.save_player_data()

func change_scene(scene_path: String) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	scene_transition_started.emit(scene_path)
	
	# Güvenli sahne geçişi (call_deferred)
	call_deferred("_do_change_scene", scene_path)

func _do_change_scene(scene_path: String) -> void:
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Sahne yüklenemedi: %s (Hata: %d)" % [scene_path, error])
	is_transitioning = false
	scene_transition_completed.emit(scene_path)

func go_to_island_map() -> void:
	change_scene("res://scenes/world/island_map.tscn")

func go_to_main_menu() -> void:
	change_scene("res://scenes/main/main_menu.tscn")

func _load_saved_progress() -> void:
	# DataManager hazır olduğunda verileri senkronize eder
	var data = DataManager.get_player_data()
	if not data.is_empty():
		total_stars = data.get("total_stars", 0)
		current_age_group = data.get("age_group", AgeGroup.AGE_2_4)
		completed_activities = data.get("completed_activities", {})
