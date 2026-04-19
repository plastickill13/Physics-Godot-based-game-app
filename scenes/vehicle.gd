extends VehicleBody3D

@export var max_engine_force: float = 250.0
@export var max_brake_force: float = 10.0
@export var max_steer_angle: float = 0.6 # Roughly 35 degrees
@export var steering_speed: float = 5.0
@export var acceleration_image: Texture2D # Drag your illustration here in the Inspector!
var has_learned_acceleration: bool = false
# NEW: The "Anti-Flip" weight. This pulls the physical center of gravity down half a meter.
@export var center_of_mass_offset: Vector3 = Vector3(0.0, 0.2, 0.0) 


@onready var engine_audio = $"engine-sounds"

# Tweak these to make the engine sound heavier or whinier
@export var idle_pitch: float = 0.8
@export var max_pitch: float = 2.0
@export var max_audio_speed: float = 20.0 # The speed where the engine screams the loudest

@onready var left_blinker = $"backlights/left-blinker"
@onready var right_blinker = $"backlights/right-blinker"

@export var blink_speed: float = 15.0 # Higher is a faster flash!

var is_driven: bool = false 

func _ready() -> void:
	# NEW: Override Godot's default math and force the heavy center of gravity down low
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = center_of_mass_offset

func _process(delta: float) -> void:
	if position.y < -100:
		global_position = Vector3(-60, 5, -16)

func _physics_process(delta: float) -> void:
	# 1. Get Inputs
	if not is_driven:
		while engine_force > 0:
			engine_force -= 0.5
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
	
	var time_sec = Time.get_ticks_msec() / 1000.0
	var flash_on = sin(time_sec * blink_speed) > 0.0

	# 2. CHECK THE STEERING DIRECTION
	# We use a small "deadzone" (0.1) so the lights don't flash 
	# if you just lightly tap the wheel or hit a bump.
	
	if steering > 0.1: 
		# Turning Left
		left_blinker.visible = flash_on
		right_blinker.visible = false
		
	elif steering < -0.1:
		# Turning Right
		left_blinker.visible = false
		right_blinker.visible = flash_on
		
	else:
		# Driving Straight (Turn both off)
		left_blinker.visible = false
		right_blinker.visible = false
	
	
	
	if is_driven:
		if not engine_audio.playing:
			engine_audio.play()
			
		
		var speed_ratio = clamp(current_speed / max_audio_speed, 0.0, 1.0)
		var target_pitch = lerp(idle_pitch, max_pitch, speed_ratio)
		engine_audio.pitch_scale = lerp(engine_audio.pitch_scale, target_pitch, 5.0 * delta)
		
		if current_speed <= 0.005:
			
			if engine_audio.playing:
				engine_audio.stop()
	
	if Input.is_action_pressed("move_forward"):
		if not has_learned_acceleration:
			has_learned_acceleration = true
			
			var desc = "Pressing the gas pedal pushes the vehicle forward.\nThe longer you hold it, the more momentum you build up!"
			InfoDialog.trigger_info("Acceleration", desc, acceleration_image)
		# Turn off the running loop if the player isn't inside
		
		
