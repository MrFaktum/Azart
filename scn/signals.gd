extends Node

#Передаёт местоположение игрока
#signal player_position_update(player_pos)

#Передает нанесенный урон игроку
signal enemy_attack(enemy_damage) #Можно подумать стоит ли этот сигнал заменять на глобальную переменную

#Передает нанесенный урон врагу
#signal player_attack(player_damage)
