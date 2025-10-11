extends Control

@export var char_per_sec: float = 10 # Number of characters to display per second

signal dialogue_finished # Signal sent when the player advances the dialogue

@onready var text_label: RichTextLabel = $Panel/RichTextLabel # Main text
@onready var next_label: Label = $Panel/Label # Little gizmo that says next

var displayed_chars: float = 0 # Internal count of number of characters to display
var content_length: int = 0 # Length of the content
var display: bool = false # Enables or disables this node's logic

func _ready() -> void:
	content_length = text_label.text.length()

func _process(delta: float) -> void:
	if display:
		_update_display(delta)

# Update the text display
func _update_display(delta):
	if content_length > displayed_chars - 1:
		text_label.visible_characters = floor(displayed_chars)
		displayed_chars += char_per_sec * delta
	else:
		# Once the content has been displayed, show the next label and send a
		# signal when the user advances dialogue
		next_label.show()
		if Input.is_action_just_pressed(&"advance_dialogue"):
			_reset_text_label()
			emit_signal("dialogue_finished")

# Reset this node
func _reset_text_label() -> void:
	text_label.visible_characters = 0
	displayed_chars = 0
	content_length = 0
	next_label.hide()
	display = false

# Public function to display dialogue
func display_dialogue(content: String) -> void:
	text_label.text = content
	content_length = content.length()
	displayed_chars = 0
	display = true
