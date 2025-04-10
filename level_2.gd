extends Node2D

#Переменные
@onready var player = $Player/Player
@onready var health_bar = $CanvasLayer/HealthBar

func _ready() -> void:
	#Изменение значениея здоровья в HealthBar
	health_bar.max_value = player.health
	health_bar.value = health_bar.max_value

func _process(delta: float) -> void:
	pass

#Получение значение здоровья от игрока
func _on_player_health_changed(new_health: Variant) -> void:
	health_bar.value = new_health
