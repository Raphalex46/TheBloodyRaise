extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if body is Player and Story.has_talked_to_union:
		Events.lock_player_movement.emit()
		Events.lock_boss.emit()
		body_entered.disconnect(_on_body_entered)
		self.set_deferred("monitoring", false)
		Music.fade_out()
		$WinDialogue.play()
