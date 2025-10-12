extends Node

# A global dialogue controller that can be called from anywhere
# forward dialogue to a display UI

var ui_dialogue: Control = null # Node to use for displaying dialogue
var dialogue_queue: Array[String]
var play_count: int = 0

# Forward the provided dialogue to the controller
func _play_dialogue(text: String):
	if ui_dialogue:
		ui_dialogue.display_dialogue(text)
	else:
		push_error("Dialogue controller: no dialogue UI node was registered!")

# Signal handler for when dialogue is done displaying
func _on_dialogue_finished() -> void:
	if dialogue_queue.is_empty() or play_count == 0:
		return
	else:
		_play_dialogue(dialogue_queue.pop_front())

# Push dialogue in the dialogue queue
func push_dialogue(text: String) -> void:
	dialogue_queue.push_back(text)

func play_queue() -> void:
	play_count = dialogue_queue.size()
	_play_dialogue(dialogue_queue.pop_front())

# Register a UI dialogue node to this autoload
func register_ui_dialogue(node: Control) -> void:
	ui_dialogue = node
	ui_dialogue.dialogue_finished.connect(_on_dialogue_finished)
