extends CharacterBody2D


@export var data: PlayerData

const SPEED = 300.0
const JUMP_VELOCITY = -600.0


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var health: float
var speed: float
var state: PlayerData.State

func _ready() -> void:
	setup(data)	

func setup(player: PlayerData):
	animated_sprite.sprite_frames = player.sprite_frames
	health = player.health
	speed = player.speed
	state = player.state

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("attack"):
		state = PlayerData.State.ATTACK
		animated_sprite.play("attack2")


	if state != PlayerData.State.ATTACK:
		if not is_on_floor():
			animated_sprite.play("jump")
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
		PlayerData.State.ATTACK:
			state = PlayerData.State.IDLE
