extends Control

#Меню работы с базой данных разработчика

#Создание обекта БД
var database : SQLite

func _ready() -> void:
	#Соединяется с БД в файлах игры
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()

func _process(delta: float) -> void:
	pass

#Создает запись в строке save вставляя данные из SaveTextEdit
func _on_insert_data_pressed() -> void:
	var data = {
		"save" : $SaveTextEdit.text
	}
	database.insert_row("players", data)

#Создает таблицу в БД
func _on_create_teble_pressed() -> void:
	var table = {
		#"id" : {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"save" : {"data_type": "text"}
	}
	database.create_table("players", table)

#Выписывает выбранные данные из БД в вывод
func _on_select_data_pressed() -> void:
	print(database.select_rows("players", "", ["save"]))

#Обновляет данные в таблице
func _on_update_data_pressed() -> void:
	database.update_rows("players", "id = %s" % int($IdTextEdit.text), {"save": $SaveTextEdit.text})

#Удаляет данные в таблице
func _on_delete_data_pressed() -> void:
	database.delete_rows("players","id = %s" % int($IdTextEdit.text))

#Можно написать костомное взаимодействие с БД
func _on_custom_select_pressed() -> void:
	pass # Replace with function body.
