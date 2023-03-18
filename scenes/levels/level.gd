extends Node2D

@export var banner_title : String
@export var banner_subtitle : String
@export var level_music : AudioStreamOggVorbis
@onready var cam : Camera2D = $Camera2D

func _ready() -> void:
	Music.play(level_music)
	#print ("Emitting banner thing")

#func _physics_process(delta: float) -> void:
	#print(cam.global_position.y)
