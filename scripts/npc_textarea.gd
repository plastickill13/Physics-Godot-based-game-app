extends Area3D
@onready var label = $"talk-label"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		label.visible = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		label.visible = false
