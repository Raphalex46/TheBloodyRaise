extends Control

func _ready() -> void:
	var sp = SaveCookieController.retrieve_savepoint()
	if sp == "run3":
		$GameOverRun3.play()
	if sp == "run4":
		$GameOverRun4.play()
	else:
		$GameOver.play()
