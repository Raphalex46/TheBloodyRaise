extends Control

@export var char_per_sec: float = 10 # Number of characters to display per second
@export var prompt: String = " >" # A simple prompt to display once text is done displaying
@onready var prompt_len: int = prompt.length() # Length of the prompt
@export var prompt_blink_freq: float = 0.5 # Blink the prompt once every x seconds

signal dialogue_finished # Signal sent when the player advances the dialogue

@onready var text_label: RichTextLabel = $Panel/RichTextLabel # Main text
@onready var sound_effect: AudioStreamPlayer = $SoundEffect # Sound effect node

@onready var dialogue_controller: Node = $"/root/DialogueController"

@onready var time_char_interval: float = 1/char_per_sec # Amount of time it takes to display a character

var elapsed_character_time: float = 0 # Time counter for displaying characters
var elapsed_blink_time: float = 0 # Same kind of counter but for blinking the prompt
var content_length: int = 0 # Length of the content
var display: bool = false # Enables or disables this node's logic
var finished: bool = false # Whether the text has finished displaying

func _ready() -> void:
	_reset_text_label()
	dialogue_controller.register_ui_dialogue(self)

func _process(delta: float) -> void:
	if display:
		_update_display(delta)

# Update the text display
func _update_display(delta: float):
	if not finished:
		_update_displayed_chars(delta)
	else:
		# Once the content has been displayed, show the next label and send a
		# signal when the user advances dialogue
		if Input.is_action_just_pressed(&"advance_dialogue"):
			_reset_text_label()
			emit_signal("dialogue_finished")
		# If text is done displaying, just blink the prompt
		_blink_prompt(delta)

# Advance the elapsed time counter, display characters and play the sound
# effect
func _update_displayed_chars(delta: float) -> void:
	elapsed_character_time += delta
	while elapsed_character_time >= time_char_interval:
		text_label.visible_characters += 1
		elapsed_character_time -= time_char_interval
		if text_label.text[text_label.visible_characters] != "":
			sound_effect.pitch_scale = randf_range(0.7, 0.9)
			sound_effect.play()
	if text_label.visible_characters == content_length:
		finished = true

# Reset this node
func _reset_text_label() -> void:
	text_label.visible_characters = 0
	content_length = 0
	elapsed_character_time = 0
	display = false

# Just blink the prompt at the specified frequency
func _blink_prompt(delta: float):
	elapsed_blink_time += delta
	if elapsed_blink_time > prompt_blink_freq:
		if text_label.visible_characters == content_length:
			text_label.visible_characters += prompt_len
			elapsed_blink_time = 0
		else:
			text_label.visible_characters = max(0, text_label.visible_characters - prompt_len)
			elapsed_blink_time = 0

# Public function to display dialogue
func display_dialogue(content: String) -> void:
	text_label.text = content + prompt
	content_length = content.length()
	display = true
	finished = false
