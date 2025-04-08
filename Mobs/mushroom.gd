extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE
}

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

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer

var player
var direction

func _ready() -> void:
	Signals.connect("player_position_update", Callable(self, "on_player_position_update"))

func _physics_process(delta: float) -> void:
# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta #delta переменная которая зависит от мощиности пк
		
	if state == CHASE:
		chase_state()

	move_and_slide()

func on_player_position_update(player_pos):
	player = player_pos

func _on_attack_range_body_entered(body: Node2D) -> void:
	state = ATTACK

func idle_state():
	animPlayer.play("Idle")
	await get_tree().create_timer(1).timeout
	$AttackDirection/AttackRange/CollisionShape2D.disabled = false
	state = CHASE
	
func attack_state():
	animPlayer.play("Attack")
	await  animPlayer.animation_finished
	$AttackDirection/AttackRange/CollisionShape2D.disabled = true
	state = IDLE

func chase_state():
	direction = (player - self.position).normalized()
	if direction.x < 0:
		anim.flip_h = true
		$AttackDirection.rotation_degrees = 180
	else:
		anim.flip_h = false
		$AttackDirection.rotation_degrees = 0
