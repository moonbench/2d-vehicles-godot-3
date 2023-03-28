extends RigidBody2D
class_name Vehicle2D

@export var steering_speed = 2.0
@export var max_power = 0.0
@export var acceleration = 1.0
@export var min_skid_speed = 350
@export var current = false : set = _update_current

@onready var wheels = $Wheels.get_children()
var driven_wheel_count = 0

var throttle = 0.0
var steering = 0.0
var brake = 0.0
var power = 0.0

signal current_changed

func _ready():
	_update_driven_wheel_count()

func _physics_process(delta: float):
	if current:
		_steering_input(delta)
		_throttle_input(delta)
		_brake_input(delta)
		_wake_if_input()

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if throttle > 0 || linear_velocity.length() > 0:
		for i in wheels.size():
			var wheel = wheels[i]
			wheel.reset_skids()
			if wheel.is_on_ground:
				_apply_forces(wheel, state)

func _apply_forces(wheel: Propulsor2D, state: PhysicsDirectBodyState2D):
	# Driving force
	if wheel.driven && throttle > 0.1:
		_apply_drive_force(wheel, state)
	
	if linear_velocity.length() > 0.1:
		# Braking force
		if wheel.brakes && get_brake(wheel) > 0.1:
			_apply_brake_force(wheel, state)
		
		# Resist-skidding force
		_apply_skid_force(wheel, state)
	else:
		# Static friction force
		apply_central_force(-mass * linear_velocity)

func _apply_drive_force(wheel: Propulsor2D, state: PhysicsDirectBodyState2D):	
	var vector = wheel.transform.x
	var magnitude = _per_wheel_engine_force(wheel)
	
	wheel.is_peeling = abs(magnitude) > 10000 && magnitude / mass > linear_velocity.length() * 2
	
	
	
	if abs(magnitude) > 0.1:
		var total_force = vector * magnitude * wheel.traction
		state.apply_force(total_force.rotated(global_rotation), wheel.position.rotated(global_rotation))

func _apply_brake_force(wheel: Propulsor2D, state: PhysicsDirectBodyState2D):
	var vector = transform.rotated(-global_rotation).x * -linear_velocity.rotated(-(global_rotation)).x
	var magnitude = _get_brake_force(wheel)
	wheel.is_brake_skidding = magnitude > 0.5 && vector.length() > min_skid_speed
	if vector.length() >= 0.1 && magnitude > 0:
		var total_force = vector * magnitude * wheel.traction
		state.apply_force(total_force.rotated(global_rotation), wheel.position.rotated(global_rotation))

func _apply_skid_force(wheel: Propulsor2D, state: PhysicsDirectBodyState2D):
	var skid_vector = _get_slide_force(wheel) + _get_spin_force(wheel)
	if wheel.is_peeling: skid_vector = skid_vector / 3
	wheel.is_side_skidding = skid_vector.length() > min_skid_speed
	if skid_vector.length() > 0:
		var skid_force = skid_vector * _get_skid_traction(wheel) * ( mass / wheels.size()) * wheel.traction
		state.apply_force(skid_force.rotated(global_rotation),  wheel.position.rotated(global_rotation))

func _per_wheel_engine_force(wheel: Propulsor2D):
	return _sign_squared(throttle) * (power / driven_wheel_count) * wheel.traction

func _get_brake_force(wheel: Propulsor2D):
	return _sign_squared(get_brake(wheel)) * clamp(
		remap(
			linear_velocity.length(),
			wheel.brake_low_speed,
			wheel.brake_high_speed,
			wheel.brake_force_slow,
			wheel.brake_force_fast),
		wheel.brake_force_fast,
		wheel.brake_force_slow)

func _get_slide_force(wheel: Propulsor2D):
	return wheel.transform.y * -linear_velocity.rotated(-(global_rotation + wheel.rotation)).y

func _get_spin_force(wheel: Propulsor2D):
	var radius = wheel.position.length()
	var tangential_velocity = radius * angular_velocity
	return wheel.transform.y.rotated(wheel.position.angle()) * -tangential_velocity

func _get_skid_traction(wheel: Propulsor2D):
	return clamp(
		remap(
			linear_velocity.length(),
			wheel.skid_low_speed,
			wheel.skid_high_speed,
			wheel.skid_traction_slow,
			wheel.skid_traction_fast),
		wheel.skid_traction_fast,
		wheel.skid_traction_slow)

func _throttle_input(delta: float):
	throttle = lerp(throttle, Input.get_action_strength("throttle"), delta * acceleration)
	power = clamp(lerp(power, lerp(0.0, max_power, throttle), delta * acceleration), 0.0, max_power)

func _steering_input(delta: float):
	steering = lerp(steering, Input.get_axis("left", "right"), delta * steering_speed)

func _brake_input(delta: float):
	brake = lerp(brake, Input.get_action_strength("brake"), delta * 10)

func get_brake(_wheel):
	return brake

func _sign_squared(value):
	return sign(value) * pow(value, 2)

func _wake_if_input():
	if sleeping && (throttle > 0.01 || brake > 0.01 || abs(steering) > 0.01):
		set_sleeping(false)

func _update_driven_wheel_count():
	driven_wheel_count = 0
	for wheel in wheels:
		if wheel.driven: driven_wheel_count += 1

func _update_current(new_value):
	current = new_value
	emit_signal("current_changed", current)
