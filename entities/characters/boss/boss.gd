extends CharacterBody3D

@export var speed: float = 5 # Walking speed
@export var acceleration: float = 2 # Walking acceleration

@export var health: int = 10 # Boss life

var target: Node3D = null # Target to chase
var _fireball_available: bool = true

var walk_vel: Vector3 # Walking velocity

# Allows the boss to take damage
func take_damage(dmg: int) -> void:
	health -= dmg
	$Sprite3D.play(&"hit")
	if health <= 0:
		# Might be a little harsh but an easy way out
		queue_free()

func _physics_process(delta: float) -> void:
	# If target locked in
	if target != null:
		if _fireball_available and $Sprite3D.animation != &"hit":
			_fireball_available = false
			$Fireball.launch(target.global_position)
			$Sprite3D.play(&"fireball")
		velocity = _chase(delta, target.global_position)
	move_and_slide()

# Handle chasing movement
func _chase(delta: float, target_position: Vector3) -> Vector3:
	var walk_dir: Vector3 = global_position.direction_to(target_position).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed, acceleration * delta)
	return walk_vel

func _on_player_presence_declared(node: Variant) -> void:
	target = node


func _on_fireball_out() -> void:
	_fireball_available = true
