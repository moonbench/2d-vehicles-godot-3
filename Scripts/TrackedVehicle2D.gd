extends TestVehicle2D
class_name TrackedVehicle2D

func _process(delta):
	super(delta)
	if linear_velocity.length() > 1:
		_update_tracks()

func _update_tracks():
	for track in wheels:
		track.update_track_mark()

func _per_wheel_engine_force(track: Track2D):
	var fwd_power = super(track)
	var steering_ratio = (sign(track.position.y) * sign(steering) * -1) * abs(steering)
	var adjusted_power = fwd_power * steering_ratio
	return adjusted_power if abs(adjusted_power * 1.5) > abs(fwd_power) else fwd_power

func get_brake(track: Track2D):
	return max(brake, 1 - min(abs(sign(track.position.y) - steering), 1))
