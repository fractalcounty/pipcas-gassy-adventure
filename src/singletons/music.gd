extends Node
class_name level_music

@export var level_music_player : AudioStreamPlayer
@export_exp_easing("positive_only") var pause_muffle_lerp : float
@export var new_cutoff_hz : float
@export var timer : Timer

@onready var music_bus : int = AudioServer.get_bus_index("Music")
@onready var old_vol : float = AudioServer.get_bus_volume_db(music_bus)
@onready var audio_effect : AudioEffectLowPassFilter = AudioServer.get_bus_effect(music_bus, 0)
@onready var starting_hz : float = audio_effect.cutoff_hz
@onready var paused : bool

func _ready() -> void:
	Events.pause_closed.connect(_on_pause_closed)
	Events.pause_opened.connect(_on_pause_opened)
	AudioServer.set_bus_effect_enabled(music_bus, 0, false)

func play(level_music) -> void:
	level_music_player.set_stream(level_music)
	level_music_player.play()

func _on_pause_closed() -> void:
	paused = false

func _on_pause_opened() -> void:
	paused = true

func _process(delta: float) -> void:
	var cur_vol : float = AudioServer.get_bus_volume_db(music_bus)
	if paused:
		AudioServer.set_bus_effect_enabled(music_bus, 0, true)
		var cutoff_hz : float = audio_effect.cutoff_hz
		var new_hz : float = lerp(cutoff_hz, new_cutoff_hz, delta*pause_muffle_lerp)
		audio_effect.cutoff_hz = new_hz
	else:
		timer.start(1)
		var new_hz : float = lerp(audio_effect.cutoff_hz, starting_hz, delta*pause_muffle_lerp)
		audio_effect.cutoff_hz = new_hz
		if timer.is_stopped():
			AudioServer.set_bus_effect_enabled(music_bus, 0, false)
