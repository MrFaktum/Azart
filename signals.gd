extends Node

#Передаёт местоположение игрока
signal player_position_update(player_pos)

#Передает нанесенный урон игроку
signal enemy_attack(enemy_damage)

#Передает нанесенный урон врагу
signal player_attack(player_damage)

#signal tips(tips_text)
