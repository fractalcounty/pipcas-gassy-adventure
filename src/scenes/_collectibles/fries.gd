extends AnimatedSprite2D

@export_group("Anatomy")
@export var anim : AnimationPlayer
@export var anim_delay : float = 1.0
@export var lerp_time : float = 0.5

@export_group("Collectible")
@export var points_worth : float = 1.0
@export var eat_sound : AudioStreamPlayer

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == Global.pipca:
		
		anim.play("eat")
		
		eat_sound.play()
		eat_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 5
		
		Global.pipca.consumer.emit_food_particles()
		Global.counter.add_points(points_worth)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
