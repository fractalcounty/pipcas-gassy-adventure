extends AnimatedSprite2D

@export var animation_player : AnimationPlayer

func start() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(animation = "TauntEffect") -> void:
	queue_free()

func clear() -> void:
	queue_free()
