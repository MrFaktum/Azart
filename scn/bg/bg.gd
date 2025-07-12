extends ParallaxBackground

#Переделать! он на всех уровнях он уникальный а где он рельно должен быть уникален так это только в menu и selectLevel

var speed = 100

#Движение Фона
func _process(delta: float) -> void:
	scroll_offset.x -= speed * delta
