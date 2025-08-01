extends Node2D

var data_base : SQLite

func _ready() -> void:
	data_base = SQLite.new()
	data_base.path="res://data.db"
	data_base.open_db()

#Изменяет БД на 1 уровень и запускает 1 уровень
func _on_new_game_pressed() -> void:
	data_base.query("UPDATE players SET save = 1;")
	get_tree().change_scene_to_file("res://scn/level_1/level.tscn")

#Открывет окно выбора уровня
func _on_select_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/selectLevel/select_level.tscn")

#Закрытие игры
func _on_quit_pressed() -> void:
	get_tree().quit()
