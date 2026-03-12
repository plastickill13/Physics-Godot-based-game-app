extends Area3D

@onready var truck = $".." # Gets the parent VehicleBody3D
@onready var truck_camera = $"../truck-camera/SpringArm3D/Camera3D" # Adjust this path to wherever your truck camera is!
@onready var label = $"door-label"
@onready var lights = $"../lights"
@onready var exit_area = $"exit-area"
@onready var pos_timer = $"../Timer"
@export var radio_sounds: Array[AudioStreamPlayer3D] = []

signal song_changed(display_name: String)

var player_node: Node3D = null
var lights_on = true
var start_music = false

func _ready() -> void:
	label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# 1. Detect if the Player is standing near the door
func _on_body_entered(body: Node3D) -> void:
	if body.name == "player" and not truck.is_driven: # Ensure your player node is named exactly "Player"
		label.visible = true
	
func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		label.visible = false		
	
	

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
	$"../door".play()
	truck.is_driven = true
	pos_timer.start()
	
	$"../engine-start".play()
	# Disable and hide the player
	player_node.set_physics_process(false)
	player_node.set_process(false)
	label.visible = false
	player_node.hide() 
	
	truck_camera.make_current()
	if !start_music:
		play_random_song()
		start_music = true

func exit_truck() -> void:
	$"../door".play()
	truck.is_driven = false
	pos_timer.stop()
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

func play_random_song():
	if radio_sounds.size() > 0:
		var random_index = randi() % radio_sounds.size()
		var selected_sound = radio_sounds[random_index]
		selected_sound.play()
		var raw_name = selected_sound.name
		var clean_name = raw_name.replace("_", " ")
		song_changed.emit(clean_name)

func _on_timer_timeout() -> void:
	player_node.global_position = $"exit-area".global_position
