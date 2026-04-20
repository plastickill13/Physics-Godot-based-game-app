extends CanvasLayer

# Drag your buttons here from the Scene Tree
@onready var resume_btn = $PanelContainer/MarginContainer/Control/VBoxContainer/resume
@onready var restart_btn = $PanelContainer/MarginContainer/Control/VBoxContainer/restart
@onready var settings_btn = $PanelContainer/MarginContainer/Control/VBoxContainer/settings
@onready var exit_btn = $PanelContainer/MarginContainer/Control/VBoxContainer/exit

func _ready() -> void:
	hide()
	
	# Connect the buttons
	resume_btn.pressed.connect(resume_game)
	restart_btn.pressed.connect(restart_game)
	settings_btn.pressed.connect(open_settings)
	exit_btn.pressed.connect(exit_to_title)

func _unhandled_input(event: InputEvent) -> void:
	# Check for Escape key or your custom menu key
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_menu"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game() -> void:
	var container = $PanelContainer
	container.scale = Vector2(0.9, 0.9)
	var tween = create_tween()
	tween.tween_property(container, "scale", Vector2.ONE, 0.15).set_ease(Tween.EASE_OUT)
	get_tree().paused = true
	show()
	# Free the mouse cursor so the player can actually click the UI!
	

func resume_game() -> void:
	get_tree().paused = false
	hide()
	# Lock the mouse back to the game window
	

func restart_game() -> void:
	# Unpause before restarting, or the new scene will load frozen!
	get_tree().paused = false 
	get_tree().reload_current_scene()

func open_settings() -> void:
	# We can hook this up to a separate Settings panel later
	print("Settings opened!")

func exit_to_title() -> void:
	get_tree().paused = false
	# Swap this string with the actual path to your Main Menu scene
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
