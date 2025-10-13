extends AnimatedSprite3D

func _on_animation_finished() -> void:
	if  animation != &"default":
		play(&"default")
