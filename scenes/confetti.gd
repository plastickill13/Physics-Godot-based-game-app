extends GPUParticles3D

func _ready() -> void:
	# Start the explosion the exact frame this scene spawns
	emitting = true
	
	# Godot 4 magic: The node has a built-in 'finished' signal when the burst ends.
	# We connect that signal directly to the 'queue_free' deletion command!
	finished.connect(queue_free)
