extends Node2D

#Создание обекта БД
var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()

#Очищает БД и запускает 1 уровень
func _on_new_game_pressed() -> void:
	database.query("UPDATE players SET save = 1;")
	get_tree().change_scene_to_file("res://level.tscn")

#Открывет окно выбора уровня
func _on_select_level_pressed() -> void:
	get_tree().change_scene_to_file("res://select_level.tscn")

#Закрытие игры
func _on_quit_pressed() -> void:
	get_tree().quit()

#Открывает окно работы с базой данных
func _on_bd_pressed() -> void:
	get_tree().change_scene_to_file("res://sql.tscn")
