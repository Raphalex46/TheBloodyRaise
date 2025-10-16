class_name SavePathDialogueLine
extends DialogueLine

@export var run_1: bool
@export var run_2: bool
@export var run_3: bool
@export var run_4: bool
@export var run_5: bool
@export var all_runs: bool

func should_play(savepoint: String) -> bool:
    if all_runs:
        return true
    match savepoint:
        "run1":
            return run_1
        "run2":
            return run_2
        "run3":
            return run_3
        "run4":
            return run_4
        "run5":
            return run_5

        _: return false
