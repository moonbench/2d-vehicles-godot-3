extends RigidBody2D
class_name Pedestrian2D

@export var current = false

@export var walking_speed = 100.0
@export var sprinting_speed = 300.0
@export var walking_backward_speed = 75.0

@export var acceleration = 2
@export var deceleration = 5
@export var turn_speed = 2.5

var velocity = Vector2.ZERO

func _physics_process(delta):
	if current:
		_turn(delta)
		_walk(delta)

func _turn(delta):
	rotation += Input.get_axis("left", "right") * delta * turn_speed

func _walk(delta):
	var walking = Input.get_axis("backward", "forward")
	var speed = walking_speed
	if walking:
		if walking < 0:
			speed = walking_backward_speed
		elif Input.is_action_pressed("sprint"):
			speed = sprinting_speed
		velocity = Vector2(lerp(velocity.rotated(-rotation).x, walking * speed, delta * acceleration), 0).rotated(rotation)
	else:
		velocity = Vector2(lerp(velocity.rotated(-rotation).x, move_toward(velocity.x, 0, speed), delta * deceleration), 0).rotated(rotation)
	apply_central_force(velocity)
