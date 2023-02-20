extends CharacterBody2D
class_name Pipca

@onready var skin = get_node("Sprite2D")
@onready var mouth = get_node("Mouth")
@onready var origin = self
var dir := 0

func _ready():
	# Static types are necessary here to avoid warnings.
	Global.pipca = self
	Global.skin = $Sprite2D

func _physics_process(delta: float) -> void:
	var origin_pos : Vector2 = (self.position)
	Events.follow_origin.emit(origin_pos)
	
