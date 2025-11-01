extends Label3D

func _get_action_key(action: String) -> String:
	return InputMap.action_get_events(action).front().as_text()

func _ready() -> void:
	if SaveCookieController.retrieve_savepoint() == SaveCookieController.SavePoint.RUN1:
		text = "Use "
		text += _get_action_key(&"move_forwards").substr(0, 1) + " "
		text += _get_action_key(&"move_left").substr(0, 1) + " "
		text += _get_action_key(&"move_backwards").substr(0, 1) + " "
		text += _get_action_key(&"move_right").substr(0, 1)
		text += " for movement"
		text += "\n\n"
		text += _get_action_key(&"shoot") + " to shoot"
	else:
		text = ""
