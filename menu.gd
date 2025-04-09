extends Node2D

#Закрытие игры
func _on_quit_pressed() -> void:
	get_tree().quit()

#Запуск уровня
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

#Открытие окна работы с базой данных
func _on_bd_pressed() -> void:
	get_tree().change_scene_to_file("res://sql.tscn")
