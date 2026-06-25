extends Node2D

func _ready() -> void:
	pass

# Изменяет макс. уровень на 1 и сохраняет на диск, затем запускает уровень
func _on_new_game_pressed() -> void:
	SaveManager.save_data["max_unlocked_level"] = 1
	SaveManager.save_game()
	
	get_tree().change_scene_to_file("res://scn/level_1/level.tscn")

#Открывет окно выбора уровня
func _on_select_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/selectLevel/select_level.tscn")

#Закрытие игры
func _on_quit_pressed() -> void:
	get_tree().quit()
