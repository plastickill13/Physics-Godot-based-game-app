extends Node3D
var resource = load("res://dialogues/test.dialogue")
# then
var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "start")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Replace with function body.
	DialogueManager.show_dialogue_balloon(resource, "start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
