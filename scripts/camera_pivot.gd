extends Node3D

@export var follow_speed: float = 6.0 # Lower is a lazier camera, higher is a tighter camera

@onready var player: CharacterBody3D = $".." # Grabs the parent Player node

func _ready() -> void:
	# Just in case you forget to check the box in the inspector, this forces it on!
	top_level = true 

func _physics_process(delta: float) -> void:
	if not player:
		return
		
	# Smoothly drag the pivot towards the player's exact global position
	global_position = global_position.lerp(player.global_position, follow_speed * delta)
