extends Area3D

@onready var truck = $".." # Gets the parent VehicleBody3D
@onready var truck_camera = $"../truck-camera/SpringArm3D/Camera3D" # Adjust this path to wherever your truck camera is!
@onready var label = $"door-label"
@onready var lights = $"../lights"
@onready var exit_area = $"exit-area"
var player_node: Node3D = null
var lights_on = true
var start_music = false
#func _ready() -> void:
	#label.visible = false
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)

# 1. Detect if the Player is standing near the door
#func _on_body_entered(body: Node3D) -> void:
	#if body.name == "player": # Ensure your player node is named exactly "Player"
		#player_node = body
		#label.visible = true
	#
#func _on_body_exited(body: Node3D) -> void:
	#if body.name == "Player":
		## ONLY clear the player variable if the truck is NOT being driven.
		## If they are inside driving, hold onto that reference!
		#if not truck.is_driven:
			#player_node = null
	#
	#label.visible = false		

# 2. Listen for the Interact button
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"): # Map "interact" to 'E' in your Project Settings > Input Map
		
		# GETTING IN: If player is near the door, and the truck is NOT being driven
		if truck.is_driven:
			exit_truck()
			return
			
		# GETTING IN: The truck must be empty...
		if not truck.is_driven:
			# ...AND we check the physics engine for exactly what is inside the Area3D RIGHT NOW.
			var bodies_in_zone = get_overlapping_bodies()
			
			for body in bodies_in_zone:
				if body.name == "player":
					# The player is physically standing here! Save them and get in.
					label.visible = true
					player_node = body
					
					enter_truck()
					return # Stop checking bodies once we find the player
			
			
	if event.is_action_pressed("lights"):
		lights_on = !lights_on
		lights.visible = lights_on
		
func enter_truck() -> void:
	truck.is_driven = true

	$"../engine-start".play()
	# Disable and hide the player
	player_node.set_physics_process(false)
	player_node.set_process(false)
	label.visible = false
	player_node.hide() 
	
	truck_camera.make_current()
	if !start_music:
		$"../radio".play()
		start_music = true

func exit_truck() -> void:
	truck.is_driven = false
	$"../engine-stop".play()
	$"../engine-sounds".stop()
	# Teleport them safely to the door
	player_node.global_position = $"exit-area".global_position 
	
	# Wake the player back up
	player_node.set_physics_process(true)
	player_node.set_process(true)
	player_node.show()
	
	# Switch back to the player's camera (assumes the player has a Camera3D child named PlayerCamera)
	player_node.get_node("CameraPivot/SpringArm3D/PlayerCamera").make_current()
