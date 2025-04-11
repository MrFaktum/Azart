extends Area2D

#(Для себя) Тестовая механика. Потом нужно удалить

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var tween = get_tree().create_tween() #суем в переменную вызов ф-ции 
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 25), 0.3) #монетка изменяет позицию по напровлению вверх на 25 в течении 0.3 секунды
		tween1.tween_property(self, "modulate:a", 0, 0.3) #монетка изменяет прозрачность к 0 в течении 0.3 секунды
		tween.tween_callback(queue_free) #когда tween заканчивается используем queue_free
		body.gold += 1
