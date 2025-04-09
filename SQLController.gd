extends Control

#Меню работы с базой данных разработчика

#(Для себя) написать коментарии что делает каждая деталь

var database : SQLite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_insert_data_pressed() -> void:
	var data = {
		"save" : $SaveTextEdit.text
	}
	database.insert_row("players", data)
	pass # Replace with function body.


func _on_create_teble_pressed() -> void:
	var table = {
		"id" : {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"save" : {"data_type": "text"}
	}
	database.create_table("players", table)
	pass # Replace with function body.


func _on_select_data_pressed() -> void:
	print(database.select_rows("players", "", ["save"]))
	pass # Replace with function body.


func _on_update_data_pressed() -> void:
	database.update_rows("players", "id = %s" % int($IdTextEdit.text), {"save": $SaveTextEdit.text})
	pass # Replace with function body.


func _on_delete_data_pressed() -> void:
	database.delete_rows("players","id = %s" % int($IdTextEdit.text))
	pass # Replace with function body.


func _on_custom_select_pressed() -> void:
	pass # Replace with function body.
