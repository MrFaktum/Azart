class_name Stats
extends Node

# Сигналы, которые будут сообщать другим узлам (например, Хелсбару) о том, что что-то изменилось
signal health_changed(current_health, max_health)
signal health_depleted # Сигнал смерти

# @export позволяет настраивать макс. здоровье прямо в Инспекторе редактора Godot
@export var max_health: int = 100
@export var damage_basic: int = 10

# Сеттер-переменная
var health: int:
	set(value):
		# Ограничиваем здоровье (не меньше 0, не больше максимума)
		health = clamp(value, 0, max_health)
		# Как только здоровье изменилось, кричим об этом всем, кто нас слушает
		# Так же мы отправляем max_health что бы максимально упростить код у HealthBar
		# это не высокая нагрузка и такой подход насколько я знаю часто практикуют в GameDev
		# конечно можно будет при надобности в будущем добавить больше сигналов
		health_changed.emit(health, max_health)
		
		# Если здоровье упало до нуля, кричим "Я УМЕР!"
		if health <= 0:
			health_depleted.emit()

func _ready() -> void:
	# При появлении на сцене восстанавливаем здоровье до максимума
	health = max_health
