extends Control

enum Mode { CONF_CALL, HUD }

@onready var conf_call = $ConfCall
@onready var hud = $Dialogue

var current_mode: Mode = Mode.CONF_CALL:
	get:
		return current_mode
	set(value):
		current_mode = value
		apply_mode()

func _ready() -> void:
	apply_mode()

func apply_mode() -> void:
	match current_mode:
		Mode.CONF_CALL:
			conf_call.process_mode = Node.PROCESS_MODE_INHERIT
			conf_call.show()
			hud.process_mode = Node.PROCESS_MODE_DISABLED
			hud.hide()
			hud.disabled = true
			Events.emit_signal("lock_player")
		Mode.HUD:
			conf_call.process_mode = Node.PROCESS_MODE_DISABLED
			conf_call.hide()
			hud.process_mode = Node.PROCESS_MODE_INHERIT
			hud.show()
			Events.emit_signal("unlock_player")
