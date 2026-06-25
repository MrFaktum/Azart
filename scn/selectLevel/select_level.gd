extends Node2D

func _ready() -> void:
	# Если максимальный разблокированный уровень меньше 2, то кнопка 2 уровня заблокирована
	if SaveManager.save_data["max_unlocked_level"] < 2:
		$level2.disabled = true

# Запускает 1 уровень
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/level_1/level.tscn")

# Запускает 2 уровень
func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/level_2/level_2.tscn")
