extends Control

@export var label : Label
@export var particle_label : PackedScene
@export var anim : AnimationPlayer

func add_points(value) -> void:
	Global.pipca.spawn_particle_label(value)
	if anim.is_playing:
		anim.stop()
	var animation_list : PackedStringArray = anim.get_animation_list()
	var random_index : int = randi() % animation_list.size()
	var random_animation: String = animation_list[random_index]
	anim.play(random_animation)
	Global.points += value
	Global.points = clamp(Global.points, 0.0, Global.max_points)
	label.text = str(Global.points)
