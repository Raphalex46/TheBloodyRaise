class_name SavePathDialogueLine
extends DialogueLine

@export var run_1: bool
@export var run_2: bool

func should_play(savepoint: String) -> bool:
    match savepoint:
        "run1":
            return run_1
        "run2":
            return run_2
        _: return false
