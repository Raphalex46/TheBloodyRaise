extends Node

# A global dialogue controller that can be called from anywhere
# forward dialogue to a display UI

@onready var ui_dialogue: UIDialogue = $"/root/HUD/Dialogue" # Node to use for displaying dialogue

var dialogue_queue: Array[String] # A queue of dialogue lines
var play_count: int = 0 # Number of dialogue lines to play

func _ready() -> void:
  ui_dialogue.dialogue_finished.connect(_on_dialogue_finished)

# Forward the provided dialogue to the controller
func _play_dialogue(text: String):
  ui_dialogue.display_dialogue(text)

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
