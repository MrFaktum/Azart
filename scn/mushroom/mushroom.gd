extends CharacterBody2D

#Изучить как работает пул объектов и обязательно его реализовать!

var is_dead: bool = false
var player
const SPEED = 100
var direction
var damage = 20
var chase = false
@onready var anim = $AnimatedSprite2D
@onready var anim_player = $AnimationPlayer
@onready var hit_box = $AttackDirection/DamageBox/HitBox/CollisionShape2D
@onready var attack_range = $AttackDirection/AttackRange/CollisionShape2D
@onready var attack_dir = $AttackDirection

#State Machine список состояний
enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	DEATH,
	RECOVER
}

#Стоит на месте
func idle_state():
	velocity.x = 0
	hit_box.disabled = true
	anim_player.play("Idle")

#Преследует
func chase_state():
	attack_range.disabled = false
	direction = (Global.player_pos - self.position).normalized()
	if direction.x < 0:
		anim.flip_h = true
		attack_dir.rotation_degrees = 180
	else:
		anim.flip_h = false
		attack_dir.rotation_degrees = 0
	velocity.x = direction.x * SPEED
	anim.play("Run")

#Вход гроком в зону агра
func _on_detector_body_entered(_body: Node2D) -> void:
	if is_dead:
		return
	state = CHASE

#Выход гроком из зоны агра
func _on_detector_body_exited(_body: Node2D) -> void:
	if is_dead:
		return
	state = IDLE

#Хит стан при получении урона
func damage_state():
	hit_box.disabled = true
	velocity.x = move_toward(velocity.x, 0, SPEED)
	attack_range.disabled = true
	hit_box.disabled = true
	anim_player.play("Damage")
	await anim_player.animation_finished
	state = CHASE

#При получении урона включение состояния получения урона
func _on_mob_health_damage_received() -> void:
	state = IDLE
	state = DAMAGE

#Анимация смерти и удаление обекта
func death_state():
	is_dead = true
	velocity.x = move_toward(velocity.x, 0, SPEED)
	#если хотим отключить несколько форм то можно использовать варианты из коментарием, а для одной как я понял лучше использовать те которые стоят
	attack_range.disabled = true #$AttackDirection/AttackRange.set_deferred("monitoring", false)
	$Detector/CollisionShape2D.disabled = true #$Detector.set_deferred("monitoring", false)
	anim_player.play("Death")
	await anim_player.animation_finished
	queue_free()

#При отсутствии здоровья включение состояния смерти
func _on_mob_health_no_health() -> void:
	state = DEATH

#Передача сигнала игроку о нанесении ему урона
func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage)

#Переход в состояние атаки когда игрок попадает в зону атаки гриба
func _on_attack_range_body_entered(_body: Node2D) -> void:
	state = ATTACK

#Атака
func attack_state():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	anim_player.play("Attack") #Тут в анимации у него есть тригер на включение HitBox на 0.6 секунде
	await  anim_player.animation_finished
	state = RECOVER

#Перезарядка удара
func recover_state():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	attack_range.disabled = true
	hit_box.disabled = true
	anim_player.play("Recover")
	await anim_player.animation_finished
	state = CHASE

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
				chase_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()
			RECOVER:
				recover_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if state == CHASE:
		chase_state()

	move_and_slide()
