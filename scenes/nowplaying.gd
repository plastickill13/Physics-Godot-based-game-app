extends Label

@export var scroll_speed: float = 40.0 # Pixels per second

@onready var container: Control = get_parent()

func _ready() -> void:
	moneyManager.track_changed.connect(update_marquee_text)

func _process(delta: float) -> void:
	# 1. Slide the text from left to right
	position.x += scroll_speed * delta
	
	# 2. Check if the text has completely left the right side of the container
	# (position.x is the left edge of the text)
	if position.x > container.size.x:
		# Teleport it to the far left, just out of sight, so it scrolls back in
		position.x = -size.x
		
func update_marquee_text(display_name: String) -> void:
	text = display_name
	position.x = 0
