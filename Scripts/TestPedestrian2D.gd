extends Pedestrian2D
class_name TestPedestrian2D

@export_node_path("Node2D") var camera_origin
var camera: Camera2D

signal status_updated

func _ready():
	camera_origin = get_node(camera_origin)	
	set_process_input(false)

func _process(delta):
	if current:
		_update_chase_camera(delta)

func _update_chase_camera(delta):
	var max = 250 / camera.zoom.x
	camera_origin.position.x = lerp(
		camera_origin.position.x,
		clamp((velocity.rotated(-rotation).x * 1.25) / (camera.zoom.x * 2.5), -max, max),
		delta * 10)

func add_camera(camera_node):
	camera_origin.add_child(camera_node)
	camera = camera_node
