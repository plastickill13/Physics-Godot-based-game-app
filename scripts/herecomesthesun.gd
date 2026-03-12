extends DirectionalLight3D

# How fast the sun moves. 
# 1.0 is pretty fast (great for testing). 0.1 is a nice, slow, cozy day.
@export var day_speed: float = 1.0 

func _process(delta: float) -> void:
	# Slowly rotate the sun around the X-axis
	# deg_to_rad converts our degrees into radians, which the engine requires
	rotate_x(deg_to_rad(day_speed * delta))
