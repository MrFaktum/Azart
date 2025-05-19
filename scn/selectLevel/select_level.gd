extends Node2D

var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()

	database.query("SELECT save FROM players")
	if database.query_result[0].save == "1":
		$level2.disabled = true

#Запускает 1 уровень
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/level_1/level.tscn")

#Запускает 2 уровень
func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/level_2/level_2.tscn")
