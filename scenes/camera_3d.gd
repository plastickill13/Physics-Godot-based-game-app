extends Camera3D

@export var target: Node3D # Drag your Truck's 'CameraTarget' here in the inspector
@export var follow_speed: float = 8.0
@export var rotation_speed: float = 5.0

func _physics_process(delta: float) -> void:
	if target:
		# 1. Smoothly follow the position
		global_position = global_position.lerp(target.global_position, follow_speed * delta)
		
		# 2. Smoothly match the rotation (so the camera turns when the truck turns)
		# We use spherical linear interpolation (slerp) for clean 3D rotation
		var current_quat = quaternion
		var target_quat = target.global_transform.basis.get_rotation_quaternion()
		
		quaternion = current_quat.slerp(target_quat, rotation_speed * delta)
