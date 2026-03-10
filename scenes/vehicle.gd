extends VehicleBody3D

@export var max_engine_force: float = 250.0
@export var max_brake_force: float = 10.0
@export var max_steer_angle: float = 0.6 # Roughly 35 degrees
@export var steering_speed: float = 5.0

# NEW: The "Anti-Flip" weight. This pulls the physical center of gravity down half a meter.
@export var center_of_mass_offset: Vector3 = Vector3(0.0, -0.5, 0.0) 


@onready var engine_audio = $"engine-sounds"

# Tweak these to make the engine sound heavier or whinier
@export var idle_pitch: float = 0.8
@export var max_pitch: float = 2.0
@export var max_audio_speed: float = 20.0 # The speed where the engine screams the loudest


var is_driven: bool = false 

func _ready() -> void:
	# NEW: Override Godot's default math and force the heavy center of gravity down low
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = center_of_mass_offset

func _physics_process(delta: float) -> void:
	# 1. Get Inputs
	if not is_driven:
		engine_force = 0.0
		brake = 10.0 # Keeps the truck from rolling away on hills!
		steering = 0.0
		return 
	
	var accel_input = Input.get_axis("move_backward", "move_forward")
	var steer_input = Input.get_axis("move_right", "move_left")
	
	# NEW: Speed-Sensitive Steering
	var current_speed = linear_velocity.length()
	# Creates a ratio: At 0 speed it's 1.0 (100% steering). As you approach 20 speed, it smoothly drops to 0.3 (30% steering).
	var steer_dampening = clamp(1.0 - (current_speed / 20.0), 0.3, 1.0)
	
	# 2. Snappy PS1 Steering (Now multiplied by our dampening factor!)
	var target_steer = steer_input * max_steer_angle * steer_dampening
	steering = lerp(steering, target_steer, steering_speed * delta)
	
	# 3. Arcade Acceleration & Braking
	if accel_input > 0:
		# Pushing forward
		engine_force = accel_input * max_engine_force
		brake = 0.0
	elif accel_input < 0:
		# Pushing backward (Braking or Reversing)
		if linear_velocity.length() > 1.0 and transform.basis.z.dot(linear_velocity.normalized()) < 0:
			brake = max_brake_force
			engine_force = 0.0
		else:
			engine_force = accel_input * max_engine_force
			brake = 0.0
	else:
		# Letting go of the gas
		engine_force = 0.0
		brake = 0.125
	
	if is_driven:
		if not engine_audio.playing:
			engine_audio.play()
			
		print(current_speed)
		var speed_ratio = clamp(current_speed / max_audio_speed, 0.0, 1.0)
		var target_pitch = lerp(idle_pitch, max_pitch, speed_ratio)
		engine_audio.pitch_scale = lerp(engine_audio.pitch_scale, target_pitch, 5.0 * delta)
		
		if current_speed <= 0.005:
			
			if engine_audio.playing:
				engine_audio.stop()
	
		# Turn off the running loop if the player isn't inside
		
		
