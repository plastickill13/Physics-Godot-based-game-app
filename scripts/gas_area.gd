extends Area3D

var player_in_zone: bool = false
@onready var label = $Label3D

func _ready() -> void:
	label.visible = false
	
func _on_body_entered(body: Node3D) -> void:
	if body.name == "player": # Or whatever your truck's node name is!
		player_in_zone = true
		label.visible = true
		# Optional: Show a UI Label here that says "Press E to Refuel"

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_in_zone = false
		label.visible = false
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_zone:
		refuel_truck()

func refuel_truck() -> void:
	# 1. How much gas do we actually need?
	var missing_fuel = moneyManager.max_fuel - moneyManager.current_fuel
	
	if missing_fuel < 1.0:
		print("Tank is already full!")
		return
		
	# 2. How much will it cost?
	var total_cost = missing_fuel * moneyManager.price_per_liter
	
	# 3. Does the player have enough money?
	if moneyManager.current_money >= total_cost:
		# Pay the toll and fill the tank!
		moneyManager.add_money(-total_cost)
		moneyManager.current_fuel = moneyManager.max_fuel
		moneyManager.fuel_changed.emit(moneyManager.current_fuel)
		
		# Optional: Play a "Cha-Ching" or liquid pouring sound!
		print("Filled up the tank for $", snapped(total_cost, 0.01))
	else:
		# They are too poor!
		# Optional: Fill it partially based on what they can afford$
		$"../deny".play()
		print("Not enough money!")
