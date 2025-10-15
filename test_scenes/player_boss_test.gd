extends Node3D

@onready var HUD

func _ready() -> void:
	Hud.current_mode = Hud.Mode.CONF_CALL
