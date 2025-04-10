extends Node2D

#Создание обекта БД
var database : SQLite

func _ready() -> void:
	#Соединяется с БД в файлах игры
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()
	
	#Обращаемся к сохранению в БД и если там написанно что игрок тоько на 1 уровне то кнопка 2 уровня выключается
	if database.query("SELECT save FROM players WHERE save = 1;") == true:
		$level2.disabled = true

#Запускает 1 уровень
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

#Запускает 2 уровень
func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://level_2.tscn")
