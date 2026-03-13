extends Area3D

@export var delivery_payout: float = 15.50
@export var confetti_scene: PackedScene

func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	# Check if the object thrown in here has the "package" tag we set up earlier!
	if body is RigidBody3D and body.is_in_group("package"):
		
		# 1. Pay the player using our new Global script
		moneyManager.add_money(delivery_payout)
		moneyManager.deliver_package()
		
		if confetti_scene:
			var new_confetti = confetti_scene.instantiate()
			# Add it to the main level tree (not inside the zone itself)
			get_tree().current_scene.add_child(new_confetti)
			# Snap the explosion exactly to where the box physically is right now!
			new_confetti.global_position = body.global_position
		# 2. Add a cozy "Cha-ching!" sound or particle effect here later
		print("Package Delivered! Earned: $", delivery_payout)
		
		# 3. Destroy the physical box so it doesn't clutter the zone
		body.queue_free()
