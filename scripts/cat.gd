extends CharacterBody3D

@export var walk_speed: float = 1.5
@export var wander_radius: float = 10.0

@onready var nav_agent = $NavigationAgent3D
@onready var wander_timer = $Timer

# IMPORTANT: Update these names if your nodes are named differently!
@onready var anim_player = $cat/AnimationPlayer
@onready var visual_mesh = $cat

# Grab the default gravity from project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	# Connect the timer so it picks a new spot every time it ticks
	wander_timer.timeout.connect(pick_new_target)
	
	# Pick the very first spot to walk to
	pick_new_target()

func _physics_process(delta: float) -> void:
	# 1. Apply gravity so the cat stays on the ground
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Check if we have arrived at our destination
	if nav_agent.is_navigation_finished():
		# Slow down to a stop
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.z = move_toward(velocity.z, 0, walk_speed)
		
		# Play the idle/sitting animation
		anim_player.stop()
	else:
		# 3. We are still walking! Find the next step on the path.
		var current_pos = global_position
		var next_pos = nav_agent.get_next_path_position()
		
		var direction = current_pos.direction_to(next_pos)
		direction.y = 0 # Keep the cat flat on the ground
		direction = direction.normalized()
		
		velocity.x = direction.x * walk_speed
		velocity.z = direction.z * walk_speed
		
		# 4. Smoothly rotate the visual mesh to face the walking direction
		if direction != Vector3.ZERO:
			var target_angle = atan2(direction.x, direction.z)
			visual_mesh.rotation.y = lerp_angle(visual_mesh.rotation.y, target_angle, 5.0 * delta)
		
		# Play the walking animation
		anim_player.play("walk")

	# Apply the movement
	move_and_slide()

func pick_new_target() -> void:
	# 1. Pick a random 3D coordinate around the cat
	var random_x = randf_range(-wander_radius, wander_radius)
	var random_z = randf_range(-wander_radius, wander_radius)
	var target_pos = global_position + Vector3(random_x, 0.0, random_z)
	
	# 2. Tell the brain to calculate a path to that spot
	nav_agent.target_position = target_pos
	
	# 3. Give the cat a random rest duration before it picks the next spot
	# It will wait between 3 and 8 seconds once it arrives before walking again
	wander_timer.start(randf_range(3.0, 8.0))
