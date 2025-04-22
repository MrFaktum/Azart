extends Node2D

#Создание обекта БД и переменные 
var database : SQLite

func _ready() -> void:
	#Соединяется с БД в файлах игры
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()
	
	#Отключение постоянного отображения подсказки и кнопок переходов в меню и на 2 уровень
	$CanvasLayer/Tips.visible = false
	$CanvasLayer/Continue.disabled = true
	$CanvasLayer/Continue.visible = false
	$CanvasLayer/Menu.disabled = true
	$CanvasLayer/Menu.visible = false

#Когда игрок входит в обасть 1 знака включает подсказку
func _on_assistant_area_entered(_area: Area2D) -> void:
	$CanvasLayer/Tips.text = ("Бег (Стрелки лево, право)
Щит (S)
Меч (D)
Подкат (Ctrl)")
	$CanvasLayer/Tips.visible = true

#Когда игрок выходит из обасти 1 знака выключает подсказку
func _on_assistant_area_exited(_area: Area2D) -> void:
	$CanvasLayer/Tips.visible = false

#Когда игрок входит в обасть 2 знака включает подсказку
func _on_assistant_2_area_entered(_area: Area2D) -> void:
	$CanvasLayer/Tips.text = ("Щит (Поглощает часть урона)
Меч (Можно создать комбо, при попадании в тайминги, увеличивающее урон)
Подкат (Игнорирует урон, имеет перезарядку)
Враги (Остерегайтесь местных обитателей, держитесь высоты или сражайтесь)
Лава (Убивает моментально)")
	$CanvasLayer/Tips.visible = true

#Когда игрок выходит из обасти 2 знака выключает подсказку
func _on_assistant_2_area_exited(a_rea: Area2D) -> void:
	$CanvasLayer/Tips.visible = false

#Переход на 2 уровень
func _on_exit_body_entered(_body: Node2D) -> void:
	#Сохранение прогресса достижения 2-го уровня в бд
	database.query("UPDATE players SET save = 2;")
	#Настройка отбражения финального экрана
	$Player.queue_free()
	$Mobs.queue_free()
	$CanvasLayer/Tips.text = ("Поздровляю вы прошли 1 уровень")
	$BG.visible = false
	$Tiles.visible = false
	$Signs.visible = false
	$Exit.queue_free()
	$LavaZone.queue_free()
	$CanvasLayer/Tips.visible = true
	$CanvasLayer/Continue.disabled = false
	$CanvasLayer/Continue.visible = true
	$CanvasLayer/Menu.disabled = false
	$CanvasLayer/Menu.visible = true

#Запускает 2 уровень
func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/level_2/level_2.tscn")

#Переход на окно главного меню
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/menu/menu.tscn")
