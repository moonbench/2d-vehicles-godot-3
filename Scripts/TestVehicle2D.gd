extends Vehicle2D
class_name TestVehicle2D

enum gears {
	PARK,
	REVERSE,
	NEUTRAL,
	DRIVE,
}

@export var gear: gears = gears.PARK
@export_node_path("Node2D") var camera_origin
var camera: Camera2D

@onready var body = $CarBody

signal status_updated

func _ready():
	super()
	camera_origin = get_node(camera_origin)
	set_process_input(false)

func _process(delta):
	if current:
		_update_chase_camera(delta)
		_emit_status()

func _input(event):
	if event.is_action_pressed("gear_down"):
		gear_down()
	elif event.is_action_pressed("gear_up"):
		gear_up()

func add_camera(camera_node):
	camera_origin.add_child(camera_node)
	camera = camera_node

func _per_wheel_engine_force(wheel):
	var value = super(wheel)
	if gear == gears.REVERSE:
		return value * -1
	elif gear == gears.DRIVE:
		return value
	else:
		return 0

func get_brake(_wheel):
	return 1 if gear == gears.PARK else brake

func gear_up():
	if gear == gears.PARK:
		gear = gears.REVERSE
	elif gear == gears.REVERSE:
		gear = gears.NEUTRAL
	elif gear == gears.NEUTRAL:
		gear = gears.DRIVE

func gear_down():
	if gear == gears.DRIVE:
		gear = gears.NEUTRAL
	elif gear == gears.NEUTRAL:
		gear = gears.REVERSE
	elif gear == gears.REVERSE:
		gear = gears.PARK

func toggle_car_body(show):
	if show:
		body.self_modulate = Color.WHITE
	else:
		body.self_modulate = Color.from_hsv(0, 0, 1, 0.3)

func _update_chase_camera(delta):
	var max = 250 / camera.zoom.x
	camera_origin.position.x = lerp(
		camera_origin.position.x,
		clamp((linear_velocity.rotated(-rotation).x * 1.25) / (camera.zoom.x * 2.5), -max, max),
		delta * 10)

func _emit_status():
	emit_signal("status_updated", {
		"throttle": throttle,
		"brake": brake,
		"steering": steering,
		"gear": gear,
		"forward_speed": abs(linear_velocity.rotated(-rotation).x),
		"power": _sign_squared(throttle) * power,
		"mass": mass,
		"sleeping": sleeping,
	})

func _update_current(new_value):
	super(new_value)
	set_process_input(current)
	if camera: camera.enabled = current
