extends RigidBody3D

@export var max_thrust: float = 30.0 # Must be > (Drone Mass + Package Mass) * 9.8
@export var tilt_torque: float = 5.0
@export var auto_level_strength: float = 3.0

func _physics_process(_delta: float) -> void:
	# 1. APPLY LIFT (Newton's Second Law: F = ma)
	if Input.is_action_pressed("thrust"): # e.g., Spacebar
		# 'basis.y' is the drone's LOCAL up direction. 
		# If the drone tilts, the thrust pushes diagonally.
		var lift_vector = basis.y * max_thrust
		apply_central_force(lift_vector)
		
	# 2. APPLY TILT (Torque for Navigation)
	# Get WASD/Arrow keys as a Vector2
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# In Godot 3D: +X is Right, -Z is Forward
	var pitch = input_dir.y * tilt_torque # Tilts nose up/down (rotates around X axis)
	var roll = -input_dir.x * tilt_torque # Tilts left/right (rotates around Z axis)
	
	# Apply rotational force to tilt the drone
	apply_torque(basis.x * pitch)
	apply_torque(basis.z * roll)
	
	# 3. AUTO-LEVELING (Stability Control)
	# Drones naturally try to level themselves when you let go of the controls.
	if input_dir.length() == 0:
		var current_up = basis.y
		var global_up = Vector3.UP
		
		# Cross product finds the axis perpendicular to both vectors, 
		# which is the exact axis we need to rotate around to correct the tilt.
		var correction_axis = current_up.cross(global_up)
		
		# Apply a restorative torque
		apply_torque(correction_axis * auto_level_strength)
