extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var state = MOVE
var gold = 0
var combo = false
var cooldown = false
var damage_multiplier = 1
@onready var health_bar = $UI/HealthBar
@onready var anim = $AnimatedSprite2D
@onready var anim_player = $AnimationPlayer
@onready var attack_dir = $AttackDirection
@onready var hit_box = $AttackDirection/DamageBox/HitBox/CollisionShape2D
@onready var stats = $Stats

#State Machine список состояний
enum {
	MOVE,
	ATTACK,
	СOMBO1,
	СOMBO2,
	BLOCK,
	SLIDE,
	DAMAGE,
	DEATH
}

func _ready() -> void:
	# Подписываем функцию Хелсбара на сигнал от Stats (зоздание связи между сигналом health_changed
	# и функцией приемником update_health, теперь они постоянно связаны и update_health
	# постоянно получает данные из health_changed как только он их отправляет)
	stats.health_changed.connect(health_bar.update_health)
	
	# Принудительно обновляем Хелсбар при старте (чтобы он был полным)
	health_bar.update_health(stats.health, stats.max_health)
	
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))

#Анимация получения урона
func damage_anim():
	hit_box.set_deferred("disabled", true)
	self.modulate = Color(1,0,0,1)
	var _tween = get_tree().create_tween() #Создание анимации свойств
	_tween.tween_property(self, "modulate", Color(1,1,1,1), 0.1)
	# Изменение цвета игрока. Если писать _tween.parallel().tween_property() то можно запускать 2 и
	# более анимации одновременно

#Получение значения урона от врага
func _on_damage_received(enemy_damage):
	if state == BLOCK:
		enemy_damage /= 2
	elif state == SLIDE:
		enemy_damage = 0
	else:
		state = DAMAGE
		damage_anim()
	stats.health -= enemy_damage
	if stats.health <= 0:
		state = DEATH

#Перезарядка подката
func freeze():
	cooldown = true
	await get_tree().create_timer(0.3).timeout
	cooldown = false

#Перемещение
func move_state():
	var _direction := Input.get_axis("left", "right") #Input.get_axis("left", "right") получает ось -1 или 1 при нажетие стрелок лево или право
	if _direction:
		velocity.x = _direction * SPEED
		if velocity.y == 0:
			anim_player.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) #move_toward(velocity.x, 0, SPEED) скорость стремиться к 0
		#Альтернатива с переменной трение velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		#FRICTION * delta защита от просадок FPS
		if velocity.y == 0:
			anim_player.play("Idle")
	
	if _direction == -1:
		anim.flip_h = true
		attack_dir.rotation_degrees = 180
	elif _direction == 1:
		anim.flip_h = false
		attack_dir.rotation_degrees = 0
	
	if Input.is_action_pressed("jump") and is_on_floor(): #Input.is_action_just_pressed("ui_accept") and is_on_floor() фиксирует нажатие на пробел когда игрок на полу
		anim_player.animation_finished
		velocity.y = JUMP_VELOCITY
		anim_player.play("Jump")
	
	if velocity.y > 0:
		anim_player.play("Fall")
	
	if Input.is_action_pressed("block"):
		state = BLOCK
	if Input.is_action_pressed("slide") and is_on_floor():
		if cooldown == false:
			state = SLIDE
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

#Подкат
func slide_state():
	if velocity.y > 0:
		anim_player.animation_finished
		anim_player.play("Fall")
	if is_on_floor() and anim.flip_h == false:
		velocity.x = 300
	elif is_on_floor() and anim.flip_h == true:
		velocity.x = -300
	anim_player.play("Slide")

	if Input.is_action_pressed("attack"):
		state = ATTACK
	
	await anim_player.animation_finished
	freeze()
	state = MOVE

#Блокирование щитом
func block_state():
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim_player.play("Block")
		if Input.is_action_just_released("block"):
			state = MOVE
	else:
		state = MOVE

#Основная атака
func attack_state():
	damage_multiplier = 1
	if Input.is_action_just_pressed("attack") and combo == true:
		state = СOMBO1
	velocity.x = move_toward(velocity.x, 0, SPEED)
	anim_player.play("Attack")
	await anim_player.animation_finished
	state = MOVE

#Комбо
func combo_state():
	combo = true
	await anim_player.animation_finished
	combo = false

#Первая атака в комбо
func combo1_state():
	damage_multiplier = 1.2
	if Input.is_action_just_pressed("attack") and combo == true:
		state = СOMBO2
	anim_player.play("Сombo1")
	await anim_player.animation_finished
	state = MOVE

#Вторая атака в комбо
func combo2_state():
	damage_multiplier = 2
	anim_player.play("Сombo2")
	await anim_player.animation_finished
	state = MOVE

#Хит стан при получении урона
func damage_state():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	anim.play("Damage")
	await anim.animation_finished
	state = MOVE

#Смерть
func death_state():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	anim_player.play("Death")
	await get_tree().create_timer(1.2).timeout
	queue_free()
	get_tree().change_scene_to_file.bind("res://scn/menu/menu.tscn").call_deferred()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	Global.player_dmg = stats.damage_basic * damage_multiplier #Подумать о переносе приравнивания в ф-ции атаки для минимизации вызовов
	
	#State Machine список состояний и какие ф-ции вызываются при определенном состоянии
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		СOMBO1:
			combo1_state()
		СOMBO2:
			combo2_state()
		BLOCK:
			block_state()
		SLIDE:
			slide_state()
		DAMAGE:
			damage_state()
		DEATH:
			death_state()

	move_and_slide()

	Global.player_pos = self.position
