extends Node2D

signal no_health()
signal damage_received()
@onready var health_bar = $HealthBar
@onready var damage_text = $DamageText
@onready var animPlayer = $AnimationPlayer

#Переход между состояниями (одновременно переменная, сигнал и ф-ция). Отображение полоски здоровья врага пока у него есть здоровье.
var health = 100:
	set (value):
		health = value
		health_bar.value = health
		health_bar.visible = true

func _ready() -> void:
	
	damage_text.modulate.a = 0
	
	health_bar.max_value = health
	health_bar.visible = false
	
#Нанесение урона только тем врагам которых ударили а не всех которые есть на сцене сразу
func _on_hurt_box_area_entered(_area: Area2D) -> void:
	await get_tree().create_timer(0.05).timeout
	health -= Global.player_dmg
	damage_text.text = str(Global.player_dmg)
	animPlayer.stop()
	animPlayer.play("damage_text")
	if health <= 0:
		health = 0
		health_bar.visible = false
		damage_text.visible = false
		emit_signal("no_health")
	else:
		emit_signal("damage_received")
