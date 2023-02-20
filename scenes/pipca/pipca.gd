extends CharacterBody2D
class_name Pipca

@onready var skin = get_node("Sprite2D")
@onready var mouth = get_node("Mouth")
@onready var origin = self

@export var footstep_sounds : RandomAudioPlayer
@export var belch_sounds : AudioStreamPlayer

func play():
	footstep_sounds.play()

func play_belch():
	belch_sounds.play()

var dir := 0

func _ready():
	Global.pipca = self
	Global.skin = $Sprite2D

func _physics_process(delta: float) -> void:
	var origin_pos : Vector2 = (self.position)
	Events.follow_origin.emit(origin_pos)
	
