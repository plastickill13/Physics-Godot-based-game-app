extends Node

# Custom signals let our HUD know exactly when to update the text
signal money_changed(new_amount)
signal packages_updated(new_count)
signal payout_earned(amount)
signal track_changed(new_title: String)
signal fuel_changed(new_amount)
var current_speed: float = 0.0
var current_money: float = 0.0
var packages_delivered: int = 0
var delivering: bool = false

var max_fuel: float = 100.0
var current_fuel: float = 100.0
var price_per_liter: float = 5.50 



func add_money(amount: float) -> void:
	current_money += amount
	payout_earned.emit(amount)
	money_changed.emit(current_money)

func deliver_package() -> void:
	packages_delivered += 1
	delivering = false
	packages_updated.emit(packages_delivered)
