extends Label

@export var anim : AnimationPlayer

func _physics_process(delta: float) -> void:
	var target_pos = get_parent().global_position + Vector2(0, -125)
	var dur : float = 5.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, 10*delta).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

func _on_timer_timeout() -> void:
	queue_free()
