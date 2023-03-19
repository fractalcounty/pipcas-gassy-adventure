extends Control
class_name Counter

@export_subgroup("Anatomy")
@export var label : Label
@export var points_label : PackedScene
@export var anim : AnimationPlayer

@export_subgroup("Points")
@export var max_points : float = 10000.0

@onready var points : float  = 0.0

func add_points(value) -> void:
	Global.pipca.consumer.emit_points_label(value)
	
	if anim.is_playing:
		anim.stop()
	
	var animation_list : PackedStringArray = anim.get_animation_list()
	var random_index : int = randi() % animation_list.size()
	var random_animation: String = animation_list[random_index]
	anim.play(random_animation)
	
	points += value
	points = clamp(points, 0.0, max_points)
	
	label.text = str(points)

func _exit_tree() -> void:
	Global.counter = null
