extends WheeledVehicle2D
class_name Trailer2D

func _ready():
	super()
	world_parent = get_parent().get_parent()
