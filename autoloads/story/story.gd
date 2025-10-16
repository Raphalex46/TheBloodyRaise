extends Node

var has_talked_to_union: bool = false
var game_over_scene: PackedScene = preload("res://scenes/game_over/game_over.tscn")
var credits_scene: PackedScene = preload("res://scenes/credits/credits.tscn")
var fade_in_out: PackedScene = preload("res://ui/fade_in_out/fade_in_out.tscn")

func _enter_tree() -> void:
	Events.player_dead.connect(_on_player_dead)

func _on_player_dead():
	get_tree().call_deferred("change_scene_to_packed", game_over_scene)

func start_fps_phase() -> void:
	Events.prepare_player_animation.emit(func(): 
		Events.change_hud_mode.emit(HUD.Mode.HUD)
		Events.start_player_animation.emit(func(): Events.unlock_player.emit()))

func player_win() -> void:
	var fade_in_out_node: AnimationPlayer = fade_in_out.instantiate()
	$/root.add_child(fade_in_out_node)
	fade_in_out_node.call_deferred("play", "LongFadeOut")
	await fade_in_out_node.animation_finished
	get_tree().call_deferred("change_scene_to_packed", credits_scene)
