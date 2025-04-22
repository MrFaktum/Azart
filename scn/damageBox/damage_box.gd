extends Node2D

#Отключение DamageBox по умолчанию
func _ready() -> void:
	$HitBox/CollisionShape2D.disabled = true


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	pass # Replace with function body.
