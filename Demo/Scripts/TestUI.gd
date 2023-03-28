extends CanvasLayer

@onready var hud = $HudUI

func vehicle_updated(stats):
	hud.update_stats(stats)
