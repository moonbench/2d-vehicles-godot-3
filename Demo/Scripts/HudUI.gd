extends Control

const HP_PER_NMS = 0.001341022089595

@onready var body_visibility_checkbutton = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/BodyVisibilityCheckButton
@onready var throttle_bar = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/GridContainer/ThrottleProgressBar
@onready var brake_bar = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/GridContainer/BrakeProgressBar2
@onready var steering = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/GridContainer/SteeringScroll
@onready var speed = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/GridContainer/SpeedOutput
@onready var gear_label = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/GridContainer/GearLabel
@onready var power_label = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/GridContainer/PowerLabel
@onready var power_hp = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/GridContainer/PowerHPLabel
@onready var mass_label = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/GridContainer/MassLabel2

func update_stats(stats):
	speed.text = "%05.0f" % stats["forward_speed"]
	power_label.text = "%05.0f" % abs(stats["power"])
	power_hp.text = "%05.0f" % abs(stats["power"] * HP_PER_NMS)
	throttle_bar.value = stats["throttle"] * 100
	brake_bar.value = stats["brake"] * 100
	steering.value = stats["steering"]
	gear_label.text = get_gear_value(stats)
	mass_label.text = "%.1f" % stats["mass"]

func get_gear_value(stats):
	var value = "PARK"
	if stats["gear"] == TestVehicle2D.gears.DRIVE:
		value = "DRIVE"
	if stats["gear"] == TestVehicle2D.gears.NEUTRAL:
		value = "NEUTRAL"
	elif stats["gear"] == TestVehicle2D.gears.REVERSE:
		value = "REVERSE"
	return value
