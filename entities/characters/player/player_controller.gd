extends CharacterBody3D

# This script's camera movement and player movement logic is heavily inspired
# (you could say it's almost an exact copy) by rbarongr's
# GodotFirstPersonController controller
# (https://github.com/rbarongr/GodotFirstPersonController) which is under the
# CC0-1.0 license.

@onready var camera : Camera3D = $Camera # Camera node

@export var speed: float = 10
@export var acceleration: float = 100

var walk_vel: Vector3 # Walking velocity
var grav_vel: Vector3 # Gravity velocity
var jump_vel: Vector3 # Jumping velocity

func _ready() -> void:
	# Capture the mouse for FPS movements
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Handle mouse motion inputs
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var dir = event.relative * 0.001
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_rotate_camera(dir)

func _physics_process(delta: float) -> void:
	velocity = _walk(delta)
	move_and_slide()


# Rotate the camera given a 2D vector of mouse motion
func _rotate_camera(dir: Vector2) -> void:
	# Camera rotation is *around* the Y axis so we use the x component of the
	# motion vector (horizontal movement)
	camera.rotation.y -= dir.x
	# Same but around the X axis, without forgetting to clamp to avoid 360° of
	# rotation around the X axis
	camera.rotation.x = clamp(camera.rotation.x - dir.y, -1.5, 1.5)

# Handle walking movement
func _walk(delta: float) -> Vector3:
	var move_dir = Input.get_vector(&"move_left", &"move_right", &"move_forwards", &"move_backwards")
	# Forward is always the direction the camera is pointing towards
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed, acceleration * delta)
	return walk_vel

