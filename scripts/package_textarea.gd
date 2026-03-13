extends Area3D
@onready var label = $"talk-label"
var player_node: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false # Replace with function body.


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
