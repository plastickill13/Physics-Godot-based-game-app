extends VehicleBody3D

@export var max_engine_force: float = 200.0
@export var max_brake_force: float = 10.0
@export var max_steer_angle: float = 0.6 # Roughly 35 degrees
@export var steering_speed: float = 5.0
var is_driven: bool = false 

func _physics_process(delta: float) -> void:
	# 1. Get Inputs
	if not is_driven:
		engine_force = 0.0
		brake = 10.0 # Keeps the truck from rolling away on hills!
		steering = 0.0
		return 
	
	var accel_input = Input.get_axis("move_backward", "move_forward")
	var steer_input = Input.get_axis("move_right", "move_left")
	
	# 2. Snappy PS1 Steering
	# This lerps the steering toward the input. If input is 0, it snaps back to center.
	var target_steer = steer_input * max_steer_angle
	steering = lerp(steering, target_steer, steering_speed * delta)
	
	# 3. Arcade Acceleration & Braking
	if accel_input > 0:
		# Pushing forward
		engine_force = accel_input * max_engine_force
		brake = 0.0
	elif accel_input < 0:
		# Pushing backward (Braking or Reversing)
		# If moving forward fast, act as a brake. If stopped, act as reverse.
		if linear_velocity.length() > 1.0 and transform.basis.z.dot(linear_velocity.normalized()) < 0:
			brake = max_brake_force
			engine_force = 0.0
		else:
			engine_force = accel_input * max_engine_force
			brake = 0.0
	else:
		# Letting go of the gas
		engine_force = 0.0
		brake = 0.125 # Let it coast naturally, or add a small number here to simulate friction
