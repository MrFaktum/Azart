extends ParallaxBackground

var speed = 100

#Движение Фона
func _process(delta: float) -> void:
	scroll_offset.x -= speed * delta
