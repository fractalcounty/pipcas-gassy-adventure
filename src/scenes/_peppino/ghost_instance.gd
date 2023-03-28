extends Node2D

@export var sprite_scene : PackedScene
@onready var sprite_instance : AnimatedSprite2D = null
var sprite : AnimatedSprite2D

func initialize(sprite: AnimatedSprite2D) -> void:
	self.sprite = sprite
	var sprite_instance : AnimatedSprite2D = sprite_scene.instantiate()
	add_child(sprite_instance)
	sprite_instance.do_thing(sprite)

func start(decay: float) -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate:a", 0.0, decay)
	tween.tween_callback(self.queue_free)
