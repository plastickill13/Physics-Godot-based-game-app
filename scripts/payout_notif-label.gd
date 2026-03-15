extends Label

func _ready() -> void:
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(self, "position:y", position.y - 50.0, 2.0).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 2.0).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(queue_free)
