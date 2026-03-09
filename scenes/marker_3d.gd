extends Marker3D

@export var package_scene: PackedScene # Drag your Package.tscn here in the inspector
@export var material_density: float = 15.0 # Kilograms per cubic meter

# You can call this function from an input or when an NPC dialogue finishes
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): # Usually the Spacebar or Enter key
		spawn_random_package()

func spawn_random_package() -> void:
	if not package_scene:
		push_error("Package scene not assigned!")
		return
		
	var new_package = package_scene.instantiate() as RigidBody3D
	
	# 1. Generate Random Dimensions (e.g., between 0.4 and 1.2 meters)
	var rand_x = randf_range(0.4, 1.0)
	var rand_y = randf_range(0.4, 1.0)
	var rand_z = randf_range(0.4, 1.0)
	var random_size = Vector3(rand_x, rand_y, rand_z)
	
	# 2. Resize the Collision Shape (Must duplicate to make it unique!)
	# 2. Resize the Collision Shape (Must duplicate to make it unique!)
	var collider = new_package.get_node("CollisionShape3D")
	collider.shape = collider.shape.duplicate() 
	collider.shape.size = random_size
	
	# 3. Resize the Visual Mesh Perfectly
	var mesh_instance = new_package.get_node("MeshInstance3D/box_A")
	
	# Get the base dimensions of whatever 3D model you attached
	var base_mesh_size = mesh_instance.mesh.get_aabb().size
	
	# Divide the target size by the base size to get the exact scale multiplier needed!
	mesh_instance.scale = random_size / base_mesh_size
	
	# 4. The Physics Calculation (Mass = Volume * Density)
	var volume = rand_x * rand_y * rand_z
	new_package.mass = volume * material_density
	
	# 5. Spawn it into the world
	add_child(new_package)
	
	# Optional: Slightly randomize the spawn rotation so it tumbles out of the chute
	new_package.rotation_degrees = Vector3(
		randf_range(0, 360),
		randf_range(0, 360),
		randf_range(0, 360)
	)
