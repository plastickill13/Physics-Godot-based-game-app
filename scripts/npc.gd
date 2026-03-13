extends CharacterBody3D

@export var target: Node3D # Drag your Player (or Truck) into this slot in the Inspector!
@export var turn_speed: float = 3.0
@export var breath_duration: float = 1.5 # How many seconds one inhale takes

@onready var visual_mesh = $skeleton 


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	start_breathing()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
	
	if not target:
		return
		
	# 1. Find the direction to the player
	var direction = global_position.direction_to(target.global_position)
	
	# 2. Calculate the rotation angle ONLY on the Y-axis
	# This ensures the NPC doesn't tilt backward into the floor if the player jumps
	var target_angle_y = atan2(direction.x, direction.z)
	
	# 3. Smoothly rotate towards the player
	rotation.y = lerp_angle(rotation.y, target_angle_y, turn_speed * delta)

func start_breathing() -> void:
	# 1. Create a Tween and tell it to loop forever
	var tween = create_tween().set_loops()
	
	# 2. Make the animation smooth like a sine wave, not rigid and robotic
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# 3. INHALE: Squash the X/Z slightly, stretch the Y up
	# tween_property(node, "property", target_value, duration_in_seconds)
	tween.tween_property(visual_mesh, "scale", Vector3(0.45, 0.6, 0.45), breath_duration)
	
	# 4. EXHALE: Return to the normal 1.0 scale
	tween.tween_property(visual_mesh, "scale", Vector3(0.5, 0.5, 0.5), breath_duration)	
