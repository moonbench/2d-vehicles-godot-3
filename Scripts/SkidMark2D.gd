extends Line2D

func _on_timer_timeout():
	$AnimationPlayer.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	queue_free()
