extends AnimatedSprite2D

@export_group("Collectible")
@export var points_worth : float = 1.0
@export var collect_sound : AudioStreamPlayer

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == Global.player:
		$AnimationPlayer.play("eat")
		collect_sound.play()
		collect_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 5
		Global.counter.add_points(points_worth)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
