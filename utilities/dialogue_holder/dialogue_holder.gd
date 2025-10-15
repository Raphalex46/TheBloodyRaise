extends Node

@export var dialogue: Array[DialogueLine] # Dialogue for this holder
@export var autoplay: bool # Whether to autoplay dialogue at start
@onready var queue_end_callback: Node = get_node_or_null("Callback")

@onready var dialogue_controller: Node = $"/root/DialogueController"

func _ready() -> void:
	dialogue_controller.queue_finished.connect(_on_queue_finished)
	if autoplay:
		push_dialogue()

func _on_queue_finished() -> void:
	if queue_end_callback:
		queue_end_callback.callback()

func push_dialogue() -> void:
	for d in dialogue:
		dialogue_controller.push_dialogue(d)
	dialogue_controller.play_queue()
