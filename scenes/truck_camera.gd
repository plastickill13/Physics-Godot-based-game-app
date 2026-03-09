extends Node3D

@export var follow_speed: float = 4.0 
@export var rotation_speed: float = 2.0 
@export var max_camera_drift: float = 15.0 # Max degrees the camera is allowed to lag behind
@export var rig_offset: Vector3 = Vector3(0.0, 0.0, 0.0)

@onready var truck: VehicleBody3D = $".."
@onready var camera: Camera3D = $SpringArm3D/Camera3Ds

func _physics_process(delta: float) -> void:
	if not truck or not camera:
		return
		
	# 1. Find the target forward angle (using positive Z so we look at the tailgate!)
	var forward = truck.global_transform.basis.z 
	var target_y = atan2(forward.x, forward.z)
	
	# 2. Calculate the lazy, smooth rotation first
	var smoothed_y = lerp_angle(rotation.y, target_y, rotation_speed * delta)
	
	# 3. THE HARD LEASH (Angle Clamping)
	# Convert our 15-degree limit into radians (the math Godot uses under the hood)
	var drift_limit_rads = deg_to_rad(max_camera_drift)
	
	# Find out exactly how far our lazy camera is from the truck's true forward direction
	var angle_diff = angle_difference(target_y, smoothed_y)
	
	# Clamp that difference so it can never exceed our limit (-15 to 15 degrees)
	var clamped_diff = clamp(angle_diff, -drift_limit_rads, drift_limit_rads)
	
	# Apply the final rotation (The truck's true angle + the allowed camera drift)
	rotation.y = target_y + clamped_diff
	
	# 4. Smooth, Predictable Follow
	var target_position = truck.global_position + rig_offset
	global_position = global_position.lerp(target_position, follow_speed * delta)
