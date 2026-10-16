class_name PlayerData
extends Resource

enum State { IDLE, WALK, RUN, ATTACK, JUMP }

@export var health: float = 100
@export var speed: float = 300
@export var state: State = State.IDLE
@export var sprite_frames: SpriteFrames
