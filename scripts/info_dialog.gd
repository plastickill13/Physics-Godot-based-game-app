extends CanvasLayer

@onready var panel = $PanelContainer
@onready var title_label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var info_image = $PanelContainer/MarginContainer/VBoxContainer/TextureRect
@onready var desc_box = $PanelContainer/MarginContainer/VBoxContainer/LabelDesc
@onready var close_button = $PanelContainer/MarginContainer/VBoxContainer/Button

func _ready() -> void:
	hide() # Make sure it's invisible when the game starts
	#close_button.pressed.connect(close_dialog)

# This is the master function any script can call to trigger the menu!
func trigger_info(title: String, description: String, texture: Texture2D) -> void:
	# 1. Load the data
	title_label.text = title
	desc_box.text = description
	info_image.texture = texture
	
	# 2. Pause the entire game
	get_tree().paused = true
	show()
	
	# 3. Add a juicy, bouncy pop-in animation
	panel.scale = Vector2.ZERO # Start infinitely small
	panel.pivot_offset = panel.size / 2.0 # Scale from the center, not the corner
	
	var tween = create_tween()
	# TRANS_BACK makes it overshoot slightly and bounce into place
	tween.tween_property(panel, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close_dialog() -> void:
	# Unpause the physics and hide the menu
	get_tree().paused = false
	hide()


func _on_button_pressed() -> void:
	
	close_dialog()
	
	 # Replace with function body.
