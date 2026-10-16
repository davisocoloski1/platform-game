extends Node2D


@onready var fall_limits = $FallLimits


func _on_fall_limits_body_entered(body: CharacterBody2D) -> void:
	get_tree().reload_current_scene()
