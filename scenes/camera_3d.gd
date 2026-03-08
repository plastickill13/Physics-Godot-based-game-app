extends Camera3D

 # Drag your Truck's 'CameraTarget' here in the inspector
@export var follow_speed: float = 8.0
@export var rotation_speed: float = 5.0

@export var smooth_speed = 2.0
@export var offset = Vector3.ZERO

func _physics_process(delta: float) -> void:

		# 1. Smoothly follow the position
	global_position = global_position.lerp(global_position, follow_speed * delta)
		
		# 2. Smoothly match the rotation (so the camera turns when the truck turns)
		# We use spherical linear interpolation (slerp) for clean 3D rotation
	var current_quat = quaternion
	var target_quat = global_transform.basis.get_rotation_quaternion()
		
	quaternion = current_quat.slerp(target_quat, rotation_speed * delta)
		

	var target_pos = global_position + offset
	global_position = global_position.lerp(target_pos, smooth_speed * delta)
	
	if(Input.is_action_just_pressed("scroll-up")):
		if(size < 10):
			size = 10
		else:
			size -= 1.0 
	if(Input.is_action_just_pressed("scroll-down")):
		if(size > 30):
			size = 30
		else:
			size += 1.0 
	if(Input.is_action_just_pressed("scroll-click")):
		size = 15

		
