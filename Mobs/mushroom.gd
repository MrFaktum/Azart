extends CharacterBody2D

#Переменные
@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var player
var direction
var damage = 20

#State Machine список состояний
enum {
	IDLE,
	ATTACK,
	CHASE
}

#Запись расположение игрока в переменную player
func on_player_position_update(player_pos):
	player = player_pos

#Состояние стояние на месте
func idle_state():
	animPlayer.play("Idle")
	await get_tree().create_timer(1).timeout
	$AttackDirection/AttackRange/CollisionShape2D.disabled = false
	state = CHASE

#Состояние преследования
func chase_state():
	direction = (player - self.position).normalized()
	if direction.x < 0:
		anim.flip_h = true
		$AttackDirection.rotation_degrees = 180
	else:
		anim.flip_h = false
		$AttackDirection.rotation_degrees = 0

#Гриб переходит в состояние атаки когда игрок попадает в зону атаки гриба
func _on_attack_range_body_entered(_body: Node2D) -> void:
	state = ATTACK

#Передача сигнала игроку о нанесении ему урона
func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage)

#Состояние стояние атаки
func attack_state():
	animPlayer.play("Attack")
	await  animPlayer.animation_finished
	$AttackDirection/AttackRange/CollisionShape2D.disabled = true
	state = IDLE

#Переход между состояниями (одновременно переменная, сигнал и ф-ция)
var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			CHASE:
				pass

func _ready() -> void:
	#Получение силгала о местонахождении игрока
	Signals.connect("player_position_update", Callable(self, "on_player_position_update"))

func _physics_process(delta: float) -> void:
	#Гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta #delta переменная которая зависит от мощиности пк

	if state == CHASE:
		chase_state()

	move_and_slide()
