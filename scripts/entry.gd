extends Area3D

var player_node: Node3D
@onready var label = $Label3D
@onready var outside = $outside
@onready var inside = $inside
var is_outside: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_node:
		if is_outside:
			player_node.global_position = inside.global_position
			is_outside = !is_outside
		else: 
			player_node.global_position = outside.global_position
			is_outside = !is_outside
		
		
		

func _on_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		player_node = body
		label.visible = true # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		player_node = null
		label.visible = false # Replace with function body.
