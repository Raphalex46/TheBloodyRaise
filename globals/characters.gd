class_name Characters
extends Object

const PLAYER: String = "You"
const BOSS: String = "Boss"

static func get_speaker_name(speaker: String):
	match speaker:
		"PLAYER": return PLAYER
		"BOSS": return BOSS
		_: return ""
