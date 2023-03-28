extends WheeledVehicle2D

@onready var front_body = $FrontBody
@onready var front_wheel = $Wheels/MotorcycleWheel

func _process(delta):
	super(delta)
	if current:
		front_body.rotation = front_wheel.rotation
		headlights.rotation = PI/2 + front_wheel.rotation
