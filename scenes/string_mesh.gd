extends MeshInstance3D

@export var point_a: Marker3D # Assign DroneHook in the inspector
@export var point_b: Marker3D # Assign PackageHook in the inspector

func _process(_delta: float) -> void:
	if point_a and point_b:
		var pos_a = point_a.global_position
		var pos_b = point_b.global_position
		
		# 1. Calculate the distance between the two hooks
		var distance = pos_a.distance_to(pos_b)
		
		# 2. Move the center of the cylinder to the exact midpoint
		global_position = (pos_a + pos_b) / 2.0
		
		# 3. Orient the cylinder to point from A to B
		# look_at points the -Z axis at the target. 
		# Since Godot's CylinderMesh stands up on the Y axis by default, 
		# we rotate it 90 degrees on the X axis so it aligns with the Z direction.
		if pos_a.is_equal_approx(pos_b) == false: # Prevents errors if they occupy the exact same space
			look_at(pos_b, Vector3.UP)
			rotation_degrees.x += 90.0 
			
		# 4. Stretch the cylinder's Y scale to match the distance
		scale.y = distance
