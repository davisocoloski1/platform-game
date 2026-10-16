extends CharacterBody2D


@export var data: PlayerData


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_cooldown: Timer =  $JumpCooldown

var health: float
var speed: float
var walk_speed: float
var run_speed: float
var jump_velocity: float
var state: PlayerData.State

var can_jump: bool = true

func _ready() -> void:
	setup(data)	

func setup(player: PlayerData):
	animated_sprite.sprite_frames = player.sprite_frames
	health = player.health
	speed = player.speed
	walk_speed = speed
	run_speed = speed * 2
	jump_velocity = player.jump_velocity
	state = player.state

func _physics_process(delta: float) -> void:
	print(velocity.y)
	if not is_on_floor():
		if is_on_wall() and velocity.y >= 0:
			velocity += get_gravity() / 5 * delta
		else:
			velocity += get_gravity() * delta


	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()) and can_jump:
		can_jump = false
		jump_cooldown.start()
		velocity.y = jump_velocity

	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if Input.is_action_just_pressed("attack"):
		state = PlayerData.State.ATTACK
		animated_sprite.play("attack2")


	if state != PlayerData.State.ATTACK:
		if not is_on_floor():
			animated_sprite.play("jump")
		elif direction and speed > walk_speed:
			state = PlayerData.State.RUN
			animated_sprite.play("run")
		elif direction:
			state = PlayerData.State.WALK
			animated_sprite.play("walk")
		else:
			state = PlayerData.State.IDLE
			animated_sprite.play("idle")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		PlayerData.State.ATTACK, PlayerData.State.RUN:
			state = PlayerData.State.IDLE


func _on_jump_cooldown_timeout() -> void:
	can_jump = true
