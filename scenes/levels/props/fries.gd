extends AnimatedSprite2D

@export var points_worth : float = 1.0
@export var eat_sound : AudioStreamPlayer
@export var timer : Timer
@export var anim : AnimationPlayer
@export var anim_delay : float = 1.0
@export var lerp_time : float = 0.5

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == Global.pipca:
		anim.play("eat")
		eat_sound.play()
		eat_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 5
		Global.pipca.spawn_eat_particles()
		Global.counter.add_points(points_worth)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
