extends CanvasLayer

@onready var money_label = $"Control/MarginContainer/VBoxContainer/money-text"
@onready var package_label = $"Control/MarginContainer/VBoxContainer/package-text"

func _ready() -> void:
	# Tell the labels to display the starting values (which are 0)
	update_money_display(moneyManager.current_money)
	update_package_display(moneyManager.packages_delivered)
	
	# "Connect" the signals so the labels update automatically whenever the GameManager shouts!
	moneyManager.money_changed.connect(update_money_display)
	moneyManager.packages_updated.connect(update_package_display)

func update_money_display(amount: float) -> void:
	# %.2f formats the math float into a clean "dollars and cents" string!
	money_label.text = "$%.2f" % amount

func update_package_display(count: int) -> void:
	package_label.text = "Packages Delivered: " + str(count)
