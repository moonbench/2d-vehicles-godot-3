extends Node2D

@onready var hud_ui = $TestUI/HudUI
@export_node_path("Node2D") var player
@export var camera_scene = preload("res://Demo/Scenes/ChaseCamera.tscn")

func _ready():
	if player:
		player = get_node(player)
		player.add_camera(camera_scene.instantiate())
		player.connect("status_updated", $TestUI.vehicle_updated)
		hud_ui.body_visibility_checkbutton.connect("toggled", player.toggle_car_body)
		player.current = true
		player.gear = TestVehicle2D.gears.DRIVE
		player.camera.set_process(true)

