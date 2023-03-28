extends Node2D
class_name Propulsor2D

@export var driven = false
@export var brakes = false

@export var traction = 1.0
@export var brake_force_fast = 10
@export var brake_force_slow = 50
@export var brake_low_speed = 100
@export var brake_high_speed = 500

@export var skid_traction_fast = 1.0
@export var skid_traction_slow = 2.0
@export var skid_low_speed = 100
@export var skid_high_speed = 500

var is_side_skidding = false
var is_peeling = false
var is_brake_skidding = false
var is_on_ground = true

func forces_against_chasis(power: float, velocity: Vector2):
	var drive_force = power * transform.x
	var slide_force = -velocity.rotated(-rotation).y * transform.y * 5
	return drive_force + slide_force
