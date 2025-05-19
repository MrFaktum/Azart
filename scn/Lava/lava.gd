extends Area2D

var damage = 100

#Отправка сигнала об уроне игроку
func _on_body_entered(_body: Node2D) -> void:
	Signals.emit_signal("enemy_attack", damage)
