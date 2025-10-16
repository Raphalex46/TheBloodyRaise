extends Control
class_name HUD

enum Mode { CONF_CALL, HUD }

@onready var conf_call = $ConfCall
@onready var hud = $Dialogue

@export var current_mode: Mode = Mode.CONF_CALL:
	get:
		return current_mode
	set(value):
		current_mode = value
		_apply_mode()

func _enter_tree() -> void:
	# Subscribe to hud change events
	Events.change_hud_mode.connect(_on_change_hud_mode)

func _ready() -> void:
	_apply_mode()

func _on_change_hud_mode(m: Mode):
	current_mode = m

func _apply_mode() -> void:
	if not is_node_ready(): return
	match current_mode:
		Mode.CONF_CALL:
			conf_call.process_mode = Node.PROCESS_MODE_INHERIT
			conf_call.show()
			hud.process_mode = Node.PROCESS_MODE_DISABLED
			hud.hide()
			hud.disabled = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Events.emit_signal("lock_player")
			conf_call.launch_initial_dialogue()
		Mode.HUD:
			conf_call.process_mode = Node.PROCESS_MODE_DISABLED
			conf_call.hide()
			conf_call.disable_dialogue()
			hud.disabled = false
			hud.process_mode = Node.PROCESS_MODE_INHERIT
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
