extends Node2D

#Переменные


func _ready() -> void:
	$CanvasLayer/Tips.visible = false
	$CanvasLayer/Menu.disabled = true
	$CanvasLayer/Menu.visible = false

#Переход на 2 уровень
func _on_exit_body_entered(body: Node2D) -> void:
	#Настройка отбражения финального экрана
	$Player.queue_free()
	$Mobs.queue_free()
	$BG.visible = false
	$TileMapLayer.visible = false
	$Exit.queue_free()
	$Lava.queue_free()
	$CanvasLayer/Tips.text = ("Поздровляю вы прошли 2 уровень")
	$CanvasLayer/Tips.visible = true
	$CanvasLayer/Menu.disabled = false
	$CanvasLayer/Menu.visible = true

#Переход на окно главного меню
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
