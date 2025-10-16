class_name Characters
extends Object

const PLAYER: String = "You"
const BOSS: String = "Boss"
const UNION: String = "Luiz Guinn"

static func get_speaker_name(speaker: String):
	match speaker:
		"PLAYER": return PLAYER
		"BOSS": return BOSS
		"UNION": return UNION
		_: return ""
