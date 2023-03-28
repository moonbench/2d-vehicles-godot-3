extends Node2D

@export var turret_rotation_speed = 2.5
@export var current = false

var desired_turret_rotation = 0

func _process(delta):
	if current:
		desired_turret_rotation += Input.get_axis("turret_left", "turret_right") * delta
		rotation = lerp_angle(rotation, desired_turret_rotation, delta * turret_rotation_speed)
