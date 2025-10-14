extends Node

# A global dialogue controller that can be called from anywhere
# forward dialogue to a display UI

signal play_dialogue(String)
signal queue_finished()

var dialogue_queue: Array[String] # A queue of dialogue lines
var play_count: int = 0 # Number of dialogue lines to play

# Send signal for the dialogue
func _play_dialogue(text: String):
	emit_signal(&"play_dialogue", text)

# Function to be called by the UI when dialogue is finished
func dialogue_finished() -> void:
	if dialogue_queue.is_empty() or play_count == 0:
		emit_signal(&"queue_finished")
		return
	else:
		_play_dialogue(dialogue_queue.pop_front())

# Push dialogue in the dialogue queue
func push_dialogue(text: String) -> void:
	dialogue_queue.push_back(text)

func play_queue() -> void:
	play_count = dialogue_queue.size()
	_play_dialogue(dialogue_queue.pop_front())
