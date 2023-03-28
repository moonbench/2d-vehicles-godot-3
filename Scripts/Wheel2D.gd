extends Propulsor2D
class_name Wheel2D

@export var steers = false
@export var reverse_steer = false

@export var steering_limit = 0.75
@export var steering_ratio = 1.0

@onready var skid_particles = $SkidParticles
@onready var parent_body = get_parent().get_parent()

var skid_mark_scene = preload("res://Scenes/SkidMark2D.tscn")
var current_mark: Node2D

func reset_skids():
	is_brake_skidding = false
	is_side_skidding = false
	is_peeling = false
	skid_particles.emitting = false

func update_steering(steering_input: float):
	if !steers: return
	if !reverse_steer:
		rotation = clamp(steering_input * steering_ratio, -steering_limit, steering_limit)
	else:
		rotation = -clamp(steering_input * steering_ratio, -steering_limit, steering_limit)

func skid_if_skidding():
	var is_skidding = is_side_skidding || is_peeling || is_brake_skidding
	skid_particles.emitting = is_skidding
	_update_skid_mark(is_skidding)

func _update_skid_mark(is_skidding: bool):
	if is_skidding:
		if !current_mark:
			current_mark = skid_mark_scene.instantiate()
			parent_body.world_parent.add_child(current_mark)
			current_mark.global_transform = Transform2D.IDENTITY
		if current_mark.points.size() < 1 || global_position.distance_to(current_mark.points[current_mark.points.size() - 1]) > 25:
			current_mark.add_point(global_position)
	elif !!current_mark:
		current_mark.add_point(global_position)
		current_mark = null
