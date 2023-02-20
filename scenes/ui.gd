extends Control

@onready var ui_animation : AnimationPlayer = $UIAnimations

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_animation.play("ease_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
