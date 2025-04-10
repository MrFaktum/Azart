extends Node2D

#Создание обекта БД и переменные 
var database : SQLite
@onready var player = $Player/Player
@onready var health_bar = $CanvasLayer/HealthBar

func _ready() -> void:
	#Соединяется с БД в файлах игры
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()
	#Изменение значениея здоровья в HealthBar
	health_bar.max_value = player.health
	health_bar.value = health_bar.max_value

func _process(delta: float) -> void:
	pass

#Получение значение здоровья от игрока
func _on_player_health_changed(new_health: Variant) -> void:
	health_bar.value = new_health

#Переход на 2 уровень
func _on_exit_body_entered(body: Node2D) -> void:
	database.query("UPDATE players SET save = 2;")
	get_tree().change_scene_to_file("res://level_2.tscn")
