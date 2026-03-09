extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MAX_TILT_DEGREES = 15.0 

@onready var camera = $CameraPivot/SpringArm3D/PlayerCamera
@onready var visual_node = $sprite # Or MeshInstance3D
@onready var dust_particles = $dust # Reference to your new particle node!

var bounce_tween: Tween 
var is_bouncing: bool = false

func _ready() -> void:
	camera.make_current()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	# Transform the 2D input into 3D space based on the camera/player orientation
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# 1. ROTATION: Face the movement direction using atan2
		# We calculate the angle between the X and Z movement vectors
		var target_y_rotation = atan2(direction.x, direction.z)
		visual_node.rotation.y = lerp_angle(visual_node.rotation.y, target_y_rotation, 15.0 * delta)
		
		# 2. TILT: Lean into the walk
		# (Assuming you want to keep the side-to-side lean we added earlier!)
		# We apply this to the Z-axis of the visual node
		var target_tilt = input_dir.x * -MAX_TILT_DEGREES
		visual_node.rotation_degrees.z = lerp(visual_node.rotation_degrees.z, target_tilt, 10.0 * delta)
		
		# 3. BOUNCE: Start the procedural animation
		if is_on_floor() and not is_bouncing:
			start_bounce_animation()
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		stop_bounce_animation()
		visual_node.rotation_degrees.z = lerp(visual_node.rotation_degrees.z, 0.0, 10.0 * delta)

	move_and_slide()

# --- ANIMATION & FX FUNCTIONS ---

func start_bounce_animation() -> void:
	is_bouncing = true
	
	if bounce_tween and bounce_tween.is_valid():
		bounce_tween.kill()
		
	bounce_tween = create_tween().set_loops() 
	
	# Move Up
	bounce_tween.tween_property(visual_node, "position:y", 0.2, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# Move Down
	bounce_tween.tween_property(visual_node, "position:y", 0.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	# THE MAGIC: Call our dust function exactly when the down-tween finishes!
	bounce_tween.tween_callback(spawn_dust)

func stop_bounce_animation() -> void:
	if not is_bouncing:
		return
		
	is_bouncing = false
	if bounce_tween and bounce_tween.is_valid():
		bounce_tween.kill()
		
	bounce_tween = create_tween()
	bounce_tween.tween_property(visual_node, "position:y", 0.0, 0.1).set_trans(Tween.TRANS_SINE)

func spawn_dust() -> void:
	# Double check we are actually on the ground (so dust doesn't spawn mid-air if we fall)
	if is_on_floor() and dust_particles:
		dust_particles.restart() # Forces the One-Shot emitter to burst immediately
