extends Area3D

@onready var truck = $".." # Gets the parent VehicleBody3D
@onready var truck_camera = $"../truck-camera/SpringArm3D/Camera3D" # Adjust this path to wherever your truck camera is!

var player_node: Node3D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# 1. Detect if the Player is standing near the door
func _on_body_entered(body: Node3D) -> void:
	if body.name == "player": # Ensure your player node is named exactly "Player"
		player_node = body

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_node = null

# 2. Listen for the Interact button
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"): # Map "interact" to 'E' in your Project Settings > Input Map
		
		# GETTING IN: If player is near the door, and the truck is NOT being driven
		if player_node and not truck.is_driven:
			enter_truck()
			
		# GETTING OUT: If the truck IS currently being driven
		elif truck.is_driven:
			exit_truck()

func enter_truck() -> void:
	truck.is_driven = true
	
	# Disable the player so they don't keep walking invisibly
	player_node.set_physics_process(false)
	player_node.set_process(false)
	player_node.hide() 
	
	# Switch to the truck's camera!
	truck_camera.make_current()

func exit_truck() -> void:
	truck.is_driven = false
	
	# Teleport the player exactly to the door's location so they don't spawn inside the truck
	player_node.global_position = global_position 
	
	# Re-enable the player
	player_node.set_physics_process(true)
	player_node.set_process(true)
	player_node.show()
	
	# Switch back to the player's camera (assumes the player has a Camera3D child named PlayerCamera)
	player_node.get_node("CameraPivot/SpringArm3D/PlayerCamera").make_current()
