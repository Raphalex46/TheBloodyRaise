class_name SavePathDialogueLine
extends DialogueLine

@export var run_1: bool
@export var run_2: bool
@export var run_3: bool
@export var run_4: bool
@export var run_5: bool
@export var all_runs: bool

func should_play(savepoint: SaveCookieController.SavePoint) -> bool:
    if all_runs:
        return true
    match savepoint:
        SaveCookieController.SavePoint.RUN1:
            return run_1
        SaveCookieController.SavePoint.RUN2:
            return run_2
        SaveCookieController.SavePoint.RUN3:
            return run_3
        SaveCookieController.SavePoint.RUN4:
            return run_4
        SaveCookieController.SavePoint.RUN5:
            return run_5

        _: return false
