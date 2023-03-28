extends Propulsor2D
class_name Track2D

@onready var skid_recipient = get_parent().get_parent().get_parent()
var track_mark_scene = preload("res://Scenes/TrackMark2D.tscn")
var current_mark: Node2D
var max_mark_length = 500

func _ready():
	_add_mark()

func reset_skids():
	pass

func update_track_mark():
	var mark_size = current_mark.points.size()
	if mark_size >= max_mark_length:
		current_mark.points.remove_at(0)
	if global_position.distance_to(current_mark.points[current_mark.points.size() - 1]) > 25:
		current_mark.add_point(global_position)

func _add_mark():
	current_mark = track_mark_scene.instantiate()
	skid_recipient.add_child.call_deferred(current_mark)
	current_mark.global_transform = Transform2D.IDENTITY
	current_mark.add_point(global_position)
