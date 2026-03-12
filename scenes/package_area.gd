extends Area3D

@onready var truck = $".."
@onready var package_location = $"../package-location"
@onready var label = $"door-label2"
var player_node: Node3D = null
var package_node: Node3D = null
var node_counter: int = 0
func _ready() -> void:
	label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("package") and not truck.is_driven: # Ensure your player node is named exactly "Player"
		package_node = body
		label.visible = true
	
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("package"):
		# ONLY clear the player variable if the truck is NOT being driven.
		# If they are inside driving, hold onto that reference!
			package_node = null
			label.visible = false
			
func _unhandled_input(event: InputEvent) -> void:
	if package_node:
		if event.is_action_pressed("interact"): 
			package_node.global_position = package_location.global_position
