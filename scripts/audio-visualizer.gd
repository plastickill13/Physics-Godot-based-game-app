extends ColorRect

@export var react_strength: float = 0.5 # How violently it bumps to the beat
@export var audio_bus_name: String = "radio-music"
@export var max_freq: float = 200.0
@export var min_freq: float = 20.0

var spectrum: AudioEffectSpectrumAnalyzerInstance

func _ready() -> void:
	# Find the Music bus and grab the Analyzer effect we added to it
	var bus_index = AudioServer.get_bus_index(audio_bus_name)
	
	# We assume the Spectrum Analyzer is the first effect (index 0) on the bus
	spectrum = AudioServer.get_bus_effect_instance(bus_index, 0)

func _process(delta: float) -> void:
	if not spectrum:
		return
		
	var magnitude = spectrum.get_magnitude_for_frequency_range(min_freq, max_freq)
	
	# The raw magnitude is tiny. Let's grab the length and multiply it heavily
	# Note: We remove the clamp() here so the bars can actually shoot up high!
	var energy = magnitude.length() * 100.0 
	
	# Keep X scale locked at 1.0. Apply the energy + strength to the Y scale only!
	var target_y = 1.0 + (energy * react_strength)
	var target_scale = Vector2(1.0, target_y)
	
	scale = scale.lerp(target_scale, 15.0 * delta)
