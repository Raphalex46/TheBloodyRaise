extends Node

@onready var HUD = $"/root/Hud"

func callback() -> void:
	HUD.current_mode = HUD.Mode.HUD
	Events.emit_signal("unlock_player")
