extends TrackedVehicle2D

@onready var turret = $Turret2D

func _ready():
	super()
	remove_child(camera_origin)
	turret.add_child(camera_origin)

func _on_current_changed(is_current):
	turret.current = is_current
