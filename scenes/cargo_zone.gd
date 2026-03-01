extends Area3D

var loaded_packages: Array = []

func _ready() -> void:
	# Connect the built-in signals via code
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	# Check if the object falling in is actually a package
	if body.name.begins_with("Package"):
		if not loaded_packages.has(body):
			loaded_packages.append(body)
			print("Package loaded! Total cargo: ", loaded_packages.size())
			
			# Optional: Add the mass of the package to calculate money later!

func _on_body_exited(body: Node3D) -> void:
	if body in loaded_packages:
		loaded_packages.erase(body)
		print("Lost a package! Total cargo: ", loaded_packages.size())
