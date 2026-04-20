extends Area3D

@onready var label = $"talk-label"
@onready var package_spawner = $"../Marker3D"

# NEW: This creates a slot in the Godot Inspector!
@export var dialogue_resource: DialogueResource 

var player_node: Node3D
var has_known = false
func _ready() -> void:
	label.visible = false 

# ... the rest of your code ...
func do_meow():
	$"../AudioStreamPlayer3D".play()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player_node:
			# Notice we use 'dialogue_resource' here instead of 'resource'
			if !has_known:
				DialogueManager.show_dialogue_balloon(dialogue_resource, "start", [self])
				has_known = true
			elif moneyManager.delivering == true:
				DialogueManager.show_dialogue_balloon(dialogue_resource, "delivering", [self])
			


func spawn_package():
	package_spawner.spawn_random_package()

func _on_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		player_node = body
		$"../AudioStreamPlayer3D2".play()
		label.visible = true # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		player_node = null
		label.visible = false # Replace with function body.
