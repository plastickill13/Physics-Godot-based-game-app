extends Area3D

@export var base_payout: float = 25.00 
# How much money you make per meter traveled
@export var pay_per_meter: float = 2.50
@export var confetti_scene: PackedScene

func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	# Check if the object thrown in here has the "package" tag we set up earlier!
	if body is RigidBody3D and body.is_in_group("package"):
		
		# 1. Pay the player using our new Global script
		var distance = body.start_position.distance_to(global_position)
		# 2. CALCULATE THE PAY
		var total_payout = base_payout + (distance * pay_per_meter)
		# 3. Pay the player the dynamic amount!
		moneyManager.add_money(total_payout)
		moneyManager.deliver_package()
		print("Distance: ", snapped(distance, 0.1), "m | Payout: P", snapped(total_payout, 0.01))
		if confetti_scene:
			var new_confetti = confetti_scene.instantiate()
			# Add it to the main level tree (not inside the zone itself)
			get_tree().current_scene.add_child(new_confetti)
			# Snap the explosion exactly to where the box physically is right now!
			new_confetti.global_position = body.global_position
		# 2. Add a cozy "Cha-ching!" sound or particle effect here later

		
		# 3. Destroy the physical box so it doesn't clutter the zone
		body.queue_free()
