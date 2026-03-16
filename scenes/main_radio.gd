extends AudioStreamPlayer3D

# These will appear in the Inspector so you can drag and drop your music!
@export var playlist: Array[AudioStream]
@export var track_names: Array[String] 

var current_track_index: int = 0

# We create a custom signal so the Radio can shout to the UI when a song changes
signal track_changed(new_title: String)

func _ready() -> void:
	# Start playing the first song as soon as the game loads
	if playlist.size() > 0:
		play_track(2)

func _unhandled_input(event: InputEvent) -> void:
	# Let the player press a button (like 'R' or D-Pad Right) to skip songs!
	# (Make sure to add "skip_track" to your Project > Input Map)
	if event.is_action_pressed("skip_track"):
		next_track()

func next_track() -> void:
	if playlist.is_empty():
		return
		
	current_track_index += 1
	
	# If we reach the end of the playlist, loop back to the first song
	if current_track_index >= playlist.size():
		current_track_index = 0 
		
	play_track(current_track_index)

func play_track(index: int) -> void:
	stream = playlist[index]
	play()
	
	var title = ""
	if index < track_names.size() and track_names[index] != "":
		title = track_names[index]
	else:
		title = stream.resource_path.get_file().get_basename().capitalize()
	moneyManager.track_changed.emit(title)
	
func _on_finished() -> void:
	next_track()
	
