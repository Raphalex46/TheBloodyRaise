class_name DialogueLine
extends Resource

@export var speaker: String
@export_multiline var line: String

func _init(p_speaker: String = "", p_line: String = ""):
	speaker = p_speaker
	line = p_line
