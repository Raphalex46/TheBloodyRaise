extends Node

@export var dialogue: Array[String] # Dialogue for this holder
@export var autoplay: bool # Whether to autoplay dialogue at start

@onready var dialogue_controller: Node = $"/root/DialogueController"

func _ready() -> void:
	if autoplay:
		push_dialogue()

func push_dialogue() -> void:
	for d in dialogue:
		dialogue_controller.push_dialogue(d)
	dialogue_controller.play_queue()
