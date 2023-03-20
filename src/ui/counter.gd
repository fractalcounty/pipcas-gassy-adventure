extends Control
class_name Counter

@export var label : Label
@export var animation_player : AnimationPlayer
@export var max_points : float = 10000.0

var points : float  = 0.0

func add_points(value) -> void:
	# Initialize floating point label, emit food chunks
	Global.player.consumer.init_points_label(value)
	Global.player.consumer.emit_food_particles()
	
	# Counter UI juice animation logic
	if animation_player.is_playing:
		animation_player.stop()
	var animation_list : PackedStringArray = animation_player.get_animation_list()
	var random_index : int = randi() % animation_list.size()
	var random_animation: String = animation_list[random_index]
	animation_player.play(random_animation)
	
	# Points handling 
	points += value
	points = clamp(points, 0.0, max_points)
	label.text = str(points)

func _exit_tree() -> void:
	Global.counter = null
