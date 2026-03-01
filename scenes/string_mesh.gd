extends MeshInstance3D

@export var drone: RigidBody3D   # Drag the main Drone node here
@export var package: RigidBody3D # Drag the main Package node here

func _process(_delta: float) -> void:
	# Check if both objects exist AND if they have their hook_marker defined
	if drone and package and drone.get("hook_marker") and package.get("hook_marker"):
		var pos_a = drone.hook_marker.global_position
		var pos_b = package.hook_marker.global_position
		
		var distance = pos_a.distance_to(pos_b)
		global_position = (pos_a + pos_b) / 2.0
		
		if pos_a.is_equal_approx(pos_b) == false:
			look_at(pos_b, Vector3.UP)
			rotation_degrees.x += 90.0 
			
		scale.y = distance
