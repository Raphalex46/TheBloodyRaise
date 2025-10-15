extends Node

func callback() -> void:
	Events.emit_signal("change_hud_mode", HUD.Mode.HUD)
	Events.emit_signal("unlock_player")
