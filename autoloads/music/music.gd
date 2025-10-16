extends AudioStreamPlayer

func fade_out() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -60, 3.0).finished.connect(
		func(): self.stop())
