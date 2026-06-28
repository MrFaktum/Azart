class_name HealthBarUI
extends TextureProgressBar

# Эта функция будет вызываться, когда Stats кричит "Здоровье изменилось!"
func update_health(current_hp: int, max_hp: int) -> void:
	self.max_value = max_hp
	self.value = current_hp
