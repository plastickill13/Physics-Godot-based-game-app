extends Area3D
@onready var label = $"talk-label"
@onready var package_spawner = $"../Marker3D"
var resource = load('res://dialogues/skelly.dialogue')
var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "start")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false # Replace with function body.
var player_node: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		player_node = body
		label.visible = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		player_node = null
		label.visible = false

func spawn_package():
	package_spawner.spawn_random_package()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player_node:
			DialogueManager.show_dialogue_balloon(resource, "start", [self])
			
