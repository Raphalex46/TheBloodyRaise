extends Control

# A simple test script for the dialogue node

@onready var dialogue: Control = $Dialogue

var dialogue_list: Array[String] = [
	"Et sur un test très très long, est-ce que l'interface défile toute seule ? Nous allons le voir tout de suite: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
	"N'oublions pas de tester un texte très long, afin de voir quel est le comportement de l'interface !",
	"Ceci est un test!",
	"Ça va ?",
	"Coucou"
	]

func _ready() -> void:
	_on_dialogue_finished()
	dialogue.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished() -> void:
	if (not dialogue_list.is_empty()):
		dialogue.display_dialogue(dialogue_list.pop_back())
