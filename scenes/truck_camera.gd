extends Node3D

# --- MOVEMENT SETTINGS ---
@export var follow_speed: float = 8.0
@export var rotation_speed: float = 5.0
@export var rig_offset: Vector3 = Vector3(0.0,0.0, 0.0) # Lifts the camera 1.5m above the truck

# --- SPEED EFFECT SETTINGS ---
@export var min_fov: float = 75.0  # Normal view when stopped
@export var max_fov: float = 95.0  # Wide view when driving fast
@export var speed_for_max_fov: float = 15.0 # How fast the truck needs to go to hit max_fov
@export var fov_transition_speed: float = 3.0

@onready var truck: VehicleBody3D = $".."
@onready var camera: Camera3D = $SpringArm3D/Camera3D # Make sure this path matches your tree!

func _ready() -> void:
	print("Camera Script Loaded!")
	print("Found Truck: ", truck)
	print("Found Camera: ", camera)

func _physics_process(delta: float) -> void:
	if not truck or not camera:
		return
		
	# 1. SMOOTH ROTATION (Steering)
	# Match the truck's Y-axis rotation so we look where the truck is going

	var target_y = truck.rotation.y
	rotation.y = lerp_angle(rotation.y, target_y, rotation_speed * delta)
	
	# 2. SMOOTH POSITION & OFFSET
	# We want to hover at the truck's position PLUS our height offset.
	var target_position = truck.global_position + rig_offset
	global_position = global_position.lerp(target_position, follow_speed * delta)
	
	# 3. DYNAMIC SPEED SENSE (FOV Shift)
	# Get the truck's current speed (length of its velocity vector)
	var current_speed = truck.linear_velocity.length()
	
	# Create a ratio from 0.0 (stopped) to 1.0 (going really fast)
	var speed_ratio = clamp(current_speed / speed_for_max_fov, 0.0, 1.0)
	
	# Calculate what the FOV should be right now
	var target_fov = lerp(min_fov, max_fov, speed_ratio)
	
	# Smoothly transition the camera's actual FOV to the target
	camera.fov = lerp(camera.fov, target_fov, fov_transition_speed * delta)
