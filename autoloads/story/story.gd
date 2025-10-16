extends Node

var has_talked_to_union: bool = false
var game_over_scene: PackedScene = preload("res://scenes/game_over/game_over.tscn")

func _enter_tree() -> void:
	Events.player_dead.connect(_on_player_dead)

func _on_player_dead():
	get_tree().call_deferred("change_scene_to_packed", game_over_scene)

func start_fps_phase() -> void:
	Events.prepare_player_animation.emit(func(): 
		Events.change_hud_mode.emit(HUD.Mode.HUD)
		Events.start_player_animation.emit(func(): Events.unlock_player.emit()))
