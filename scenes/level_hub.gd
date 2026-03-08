extends Node3D
#
#const LEVEL_SCENES: Array[PackedScene] = [
	#preload("res://scenes/level_1_training_yard.tscn"),
	#preload("res://scenes/level_2_industrial_slalom.tscn"),
	#preload("res://scenes/level_3_bridge_run.tscn"),
#]
#
#var current_level_index: int = -1
#var current_level: Node = null
#
#
#func _ready() -> void:
	#_load_level(0)
	#print("Level controls: [1] Training Yard, [2] Industrial Slalom, [3] Bridge Run, [R] Reload current level")
#
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventKey and event.pressed and not event.echo:
		#match event.keycode:
			#KEY_1:
				#_load_level(0)
			#KEY_2:
				#_load_level(1)
			#KEY_3:
				#_load_level(2)
			#KEY_R:
				#if current_level_index >= 0:
					#_load_level(current_level_index)
#
#
#func _load_level(index: int) -> void:
	#if index < 0 or index >= LEVEL_SCENES.size():
		#return
#
	#if is_instance_valid(current_level):
		#current_level.queue_free()
#
	#current_level = LEVEL_SCENES[index].instantiate()
	#add_child(current_level)
	#current_level_index = index
	#print("Loaded level ", index + 1)
