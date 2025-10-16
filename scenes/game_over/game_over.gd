extends Control

func _ready() -> void:
	var sp = SaveCookieController.retrieve_savepoint()
	match sp:
		SaveCookieController.SavePoint.RUN3:
			$GameOverRun3.play()
			DialogueController.queue_finished.connect(func(): $GameOver.play(), CONNECT_ONE_SHOT)
		SaveCookieController.SavePoint.RUN4:
			$GameOverRun4.play()
			DialogueController.queue_finished.connect(func():
				$GameOver.play(), CONNECT_ONE_SHOT)
		_: $GameOver.play()
	# At each run, when the player dies, we set the savepoint
	if (sp < SaveCookieController.SavePoint.RUN5):
		var new_sp = SaveCookieController.next_savepoint()
		SaveCookieController.set_savepoint(new_sp)
