extends Node

@export var dialogue: Array[SavePathDialogueLine] # Dialogue for this holder
@export var autoplay: bool # Whether to autoplay dialogue at start
@onready var queue_end_callback: Node = get_node_or_null("Callback")

@onready var dialogue_controller: Node = $"/root/DialogueController"

var savepoint: SaveCookieController.SavePoint = SaveCookieController.SavePoint.RUN1

func _ready() -> void:
	savepoint = SaveCookieController.retrieve_savepoint()
	if autoplay:
		play()

func _on_queue_finished() -> void:
	if queue_end_callback:
		queue_end_callback.callback()

func play() -> void:
	for d in dialogue:
		if d and d.should_play(savepoint):
			dialogue_controller.push_dialogue(d)
	dialogue_controller.play_queue()
	dialogue_controller.queue_finished.connect(_on_queue_finished, CONNECT_ONE_SHOT)
