extends CanvasLayer

@onready var money_label = $"Control/MarginContainer/VBoxContainer/money-text"
@onready var package_label = $"Control/MarginContainer/VBoxContainer/package-text"
@onready var delivered_package_sfx = $delivered
@onready var notif_container = $"Control/MarginContainer/VBoxContainer/notif-zone"
# Drag your new Speedometer label here from the Scene Tree!
@onready var speed_label = $Control/MarginContainer/VBoxContainer/Control/Speedometer
@onready var fuel_gauge = $Control/MarginContainer/VBoxContainer/Control2/ProgressBar
func _process(delta: float) -> void:
	# 1. Grab the raw speed (m/s) from our GameManager
	var raw_speed = moneyManager.current_speed
	
	# 2. CONVERT THE MATH!
	# To use MPH: multiply by 2.237
	# To use KM/H: multiply by 3.6
	var display_speed = raw_speed * 2.237 
	
	# 3. Round the number so it doesn't flicker with crazy decimals, and display it!
	speed_label.text = str(round(display_speed)) + " MPH"
@export var payout_notif: PackedScene
func _ready() -> void:
	# Tell the labels to display the starting values (which are 0)
	update_money_display(moneyManager.current_money)

	update_package_display(moneyManager.packages_delivered)
	fuel_gauge.max_value = moneyManager.max_fuel
	fuel_gauge.value = moneyManager.current_fuel
	
	# Listen for the fuel dropping!
	moneyManager.fuel_changed.connect(update_fuel_ui)
	# "Connect" the signals so the labels update automatically whenever the GameManager shouts!
	moneyManager.money_changed.connect(update_money_display)
	moneyManager.packages_updated.connect(update_package_display)
	moneyManager.payout_earned.connect(spawn_payout_notification)
	
func update_money_display(amount: float) -> void:
	# %.2f formats the math float into a clean "dollars and cents" string!
	money_label.text = "P%.2f" % amount

func update_package_display(count: int) -> void:
	package_label.text = "Packages Delivered: " + str(count)
	delivered_package_sfx.play()

func update_fuel_ui(new_amount: float) -> void:
	fuel_gauge.value = new_amount
	
func spawn_payout_notification(amount: float) -> void:
	# 1. Create a brand new copy of our floating label
	var new_notif = payout_notif.instantiate()

	new_notif.text = "+P%.2f" % amount
	notif_container.add_child(new_notif)	
