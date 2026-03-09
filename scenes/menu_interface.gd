extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$AudioStreamPlayer.stop()
	get_tree().change_scene_to_file("res://scenes/level_1_training_yard.tscn")

func _on_settingsbutton_pressed() -> void:
	print("Options menu not implemented yet")  # Replace with function body.


func _on_exitbutton_pressed() -> void:
	get_tree().quit() # Replace with function body.
