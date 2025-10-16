extends AnimatedSprite3D

func _handle_shot(hit_position: Variant) -> void:
	global_position = hit_position
	play("bullet_%d" % randi_range(1, 4))
	visible = true
	await get_tree().create_timer(0.5).timeout
	queue_free()
	

func _on_player_shot_fired(hit_position: Variant) -> void:
	# duplicate the bullet
	var new_bullet = duplicate()
	get_parent().add_child(new_bullet)
	new_bullet._handle_shot(hit_position)
