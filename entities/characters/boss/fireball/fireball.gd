extends Area3D

@export var speed: float = 5
@export var acceleration: float = 5
@export var damage: float = 2

# Signal that the fireball has done its course
signal fireball_out

var _launched: bool = false
var _velocity: Vector3 = Vector3.ZERO

# Setup and launch the fireball
func launch(target: Vector3):
	_launched = true
	visible = true
	top_level = true
	_velocity = global_position.direction_to(target).normalized() * speed
	$Timer.start()

func _physics_process(delta: float) -> void:
	if _launched:
		translate(_velocity * acceleration * delta)

# Get the fireball back to the user
func _reset():
	_launched = false
	visible = false
	top_level = false
	global_position = get_parent().global_position
	position = Vector3.ZERO
	fireball_out.emit()

func _on_body_entered(body: Node3D) -> void:
	if _launched and body != get_parent():
		# If the body takes damage, make it
		print(body)
		if body.has_method(&"take_damage"):
			body.take_damage(damage)
		_reset()

func _on_timer_timeout() -> void:
	# Prevent lost fireballs
	_reset()
