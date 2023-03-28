extends Camera2D

@export var min_zoom = 4.0
@export var max_zoom = 0.2

@onready var target_zoom = zoom.x

func _ready():
	set_process(false)

func _process(delta):
	if zoom.x != target_zoom:
		zoom.x = lerp(zoom.x, target_zoom, delta * 10)
		zoom.y = zoom.x

func _input(event):
	if event.is_action_pressed("zoom_in"):
		target_zoom = clamp(zoom.x * 1.2, max_zoom, min_zoom)
	elif event.is_action_pressed("zoom_out"):
		target_zoom = clamp(zoom.x * 0.8, max_zoom, min_zoom)
	elif event.is_action_pressed("zoom_step"):
		if zoom.x >= min_zoom * 0.8:
			target_zoom = max_zoom
		else:
			target_zoom = clamp(zoom.x * 1.5, max_zoom, min_zoom)
