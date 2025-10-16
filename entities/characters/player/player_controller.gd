class_name Player
extends CharacterBody3D

# This script's camera movement and player movement logic is heavily inspired
# (you could say it's almost an exact copy) by rbarongr's
# GodotFirstPersonController controller
# (https://github.com/rbarongr/GodotFirstPersonController) which is under the
# CC0-1.0 license.

@export var locked: bool # If player controls are locked, player input is ignored
@export var camera_locked: bool # Camera is locked
@export var movement_locked: bool # Player movement is locked
@export var speed: float = 5 # Walking speed
@export var acceleration: float = 40 # Walking acceleration
@export var jump_height: float = 1 # Jumping height

@export var health: int = 10 # Player life total

@export var weapon_range: float = 1000 # Weapon range
@export var weapon_damage: int = 2 # Weapon damage

@onready var camera : Camera3D = $Camera # Camera node
@onready var weapon : AnimatedSprite3D = $Camera/Weapon # Weapon node
@onready var anim_player: AnimationPlayer = $Camera/AnimationPlayer

signal shot_fired(hit_position)
@warning_ignore_start("UNUSED_SIGNAL")
signal presence_declared(node)
@warning_ignore_restore("UNUSED_SIGNAL")

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var walk_vel: Vector3 # Walking velocity
var grav_vel: Vector3 # Gravity velocity
var jump_vel: Vector3 # Jumping velocity

func _enter_tree() -> void:
		# Subscribe to the lock / unlock events
	Events.lock_player.connect(_on_player_lock)
	Events.lock_player_movement.connect(_on_lock_player_movement)
	Events.unlock_player.connect(_on_player_unlock)
	Events.prepare_player_animation.connect(_on_prepare_player_animation)
	Events.start_player_animation.connect(_on_start_player_animation)

# Handle mouse motion inputs
func _unhandled_input(event: InputEvent) -> void:
	if camera_locked:
		return
	if event is InputEventMouseMotion:
		var dir = event.relative * 0.001
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_rotate_camera(dir)
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if movement_locked:
		return
	# Handle shoots
	if Input.is_action_just_pressed(&"shoot") and weapon.animation == &"default":
		_shoot()
	# Handle jumps
	var jumping: bool
	if Input.is_action_just_pressed(&"jump"):
		jumping = true
	# Add up all computed velocity and move
	velocity = _walk(delta) + _gravity(delta) + _jump(delta, jumping)
	move_and_slide()

# Cast a shooting ray
func _shoot():
	# Play shooting animation
	weapon.play(&"shooting")
	$GunShotSoundEffect.play()
	
	# Get ray origin
	var space_state = get_world_3d().direct_space_state
	var centerpos = get_viewport().get_visible_rect().size / 2
	var origin = camera.project_ray_origin(centerpos)
	
	# Compute ray end and query
	var end = origin + camera.project_ray_normal(centerpos) * weapon_range
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.exclude = [self]

	# Cast ray and interpret result
	var result = space_state.intersect_ray(query)
	if result.has(&"position"):
		shot_fired.emit(result.position)
	if result.has(&"collider"):
		if result.collider.has_method(&"take_damage"):
			result.collider.take_damage(weapon_damage)

# Allows the player to take damage
func take_damage(damage: int):
	health -= damage
	if health <= 0:
		Events.player_dead.emit()

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

# Handle velocity due to gravity
func _gravity(delta: float) -> Vector3:
	if is_on_floor():
		grav_vel = Vector3.ZERO
	else:
		grav_vel = grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

# Handle jump velocity
func _jump(delta: float, jumping: bool) -> Vector3:
	if jumping:
		# Only give jump impulse if on the floor
		if is_on_floor():
			jump_vel = Vector3(0, sqrt(2 * jump_height * gravity), 0)
		return jump_vel
	if is_on_floor() or is_on_ceiling_only():
		jump_vel = Vector3.ZERO
	else:
		jump_vel = jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel
	
func _on_player_lock() -> void:
	movement_locked = true
	camera_locked = true

func _on_player_unlock() -> void:
	movement_locked = false
	camera_locked = false

func _on_prepare_player_animation(callback: Callable) -> void:
	anim_player.play("PreparePCLookAway")
	await anim_player.animation_finished
	callback.call()

func _on_start_player_animation(callback: Callable) -> void:
	anim_player.play("PCLookAway")
	await anim_player.animation_finished
	callback.call()

func _on_lock_player_movement() -> void:
	movement_locked = true
