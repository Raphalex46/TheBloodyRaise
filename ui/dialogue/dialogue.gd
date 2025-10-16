class_name UIDialogue

extends Control

@export var char_per_sec: float = 10 # Number of characters to display per second
@export var disabled: bool = false

@onready var text_label: RichTextLabel = $Panel/RichTextLabel # Main text
@onready var dialogue_controller: Node = $"/root/DialogueController"
@onready var blink_prompt: RichTextLabel = $"Panel/RichTextLabel/NextDialogue"
@onready var blink_prompt_anim: AnimationPlayer = $"Panel/RichTextLabel/NextDialogue/AnimationPlayer"

@onready var time_char_interval: float = 1/char_per_sec # Amount of time it takes to display a character

var elapsed_character_time: float = 0 # Time counter for displaying characters
var elapsed_blink_time: float = 0 # Same kind of counter but for blinking the prompt
var content_length: int = 0 # Length of the content
var display: bool = false # Enables or disables this node's logic
var finished: bool = false # Whether the text has finished displaying
var current_character: String

func _ready() -> void:
	_reset_text_label()
	dialogue_controller.play_dialogue.connect(display_dialogue)

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
			dialogue_controller.dialogue_finished()

# Advance the elapsed time counter, display characters and play the sound
# effect
func _update_displayed_chars(delta: float) -> void:
	elapsed_character_time += delta
	while elapsed_character_time >= time_char_interval and text_label.visible_characters < content_length:
		elapsed_character_time -= time_char_interval
		if text_label.text[text_label.visible_characters] != "" and not(text_label.visible_characters % int(char_per_sec / 10)):
			_play_speaker_sound()
		text_label.visible_characters += 1
	if text_label.visible_characters == content_length:
		# If text is done displaying, just blink the prompt and set finished to true
		_display_blink_prompt()
		finished = true

func _play_speaker_sound() -> void:
	var sound_effect: AudioStreamPlayer
	match current_character:
		"PLAYER":
			sound_effect = $SoundEffectOtamatone
			sound_effect.pitch_scale = randf_range(0.6, 0.8)
			sound_effect.play()
		"BOSS":
			sound_effect = $SoundEffectBass
			sound_effect.pitch_scale = randf_range(0.7, 0.9)
			sound_effect.play()
		"UNION":
			sound_effect = $SoundEffectGuitar
			sound_effect.pitch_scale = randf_range(0.7, 0.9)
			sound_effect.play()

# Reset this node
func _reset_text_label() -> void:
	text_label.visible_characters = 0
	content_length = 0
	elapsed_character_time = 0
	display = false
	_hide_blink_prompt()
	hide()

func _hide_blink_prompt() -> void:
	blink_prompt_anim.stop()
	blink_prompt.hide()

# Just blink the prompt at the specified frequency
func _display_blink_prompt() -> void:
	blink_prompt.show()
	blink_prompt_anim.play("Blink")

# Public function to display dialogue
func display_dialogue(line: DialogueLine) -> void:
	print(line.line)
	if not disabled:
		var speaker = Characters.get_speaker_name(line.speaker)
		text_label.text = speaker + "\n\n" + line.line
		text_label.visible_characters = speaker.length()
		content_length = text_label.text.length()
		display = true
		finished = false
		current_character = line.speaker
		show()
