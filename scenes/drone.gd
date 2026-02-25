extends RigidBody3D

@export var max_thrust: float = 40.0 
@export var tilt_torque: float = 5.0 # Increased significantly for sharper tilting
@export var auto_level_strength: float = 15.0

# Helpful for testing: automatically counters gravity
@export var auto_hover: bool = true 

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# --- 1. LIFT & PROPULSION ---
	var current_thrust = 0.0
	
	if auto_hover:
		# Calculate exact force needed to hover (Mass * Gravity)
		# ProjectSettings.get_setting("physics/3d/default_gravity") is usually 9.8
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		current_thrust += mass * gravity
		
	if Input.is_action_pressed("thrust"): # e.g., Spacebar
		current_thrust += max_thrust
		
	# Apply the total force along the drone's LOCAL up axis (basis.y)
	if current_thrust > 0:
		apply_central_force(basis.y * current_thrust)
		
	# --- 2. TILTING (Steering) ---
	if input_dir.length() > 0:
		# Apply torque to lean the drone forward/back (pitch) and left/right (roll)
		var pitch = input_dir.y * tilt_torque
		var roll = -input_dir.x * tilt_torque
		
		apply_torque(basis.x * pitch)
		apply_torque(basis.z * roll)
	else:
		# --- 3. AUTO-LEVELING ---
		# Only level out if the player lets go of the movement keys
		var current_up = basis.y
		var correction_axis = current_up.cross(Vector3.UP)
		apply_torque(correction_axis * auto_level_strength)
