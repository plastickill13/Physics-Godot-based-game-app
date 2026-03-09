extends Node

# Custom signals let our HUD know exactly when to update the text
signal money_changed(new_amount)
signal packages_updated(new_count)

var current_money: float = 0.0
var packages_delivered: int = 0

func add_money(amount: float) -> void:
	current_money += amount
	money_changed.emit(current_money)

func deliver_package() -> void:
	packages_delivered += 1
	packages_updated.emit(packages_delivered)
