extends Node2D

#Создание обекта БД
var database : SQLite

func _ready() -> void:
	#Соединяется с БД в файлах игры
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()

	#Создаем запрос
	database.query("SELECT save FROM players")
	#Обращаемся к последнему запросу достаем от туда нужный элемент и если там написанно что игрок тоько на 1 уровне то кнопка 2 уровня выключается
	if database.query_result[0].save == "1":
		$level2.disabled = true

#Запускает 1 уровень
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

#Запускает 2 уровень
func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://level_2.tscn")
