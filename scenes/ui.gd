extends Control

@export var anim : AnimationPlayer

func _ready() -> void:
	anim.play("ease_in")

func _process(delta: float) -> void:
	pass
