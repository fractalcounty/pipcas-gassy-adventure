extends Marker2D

@onready var rotation_point = get_parent().global_position
var rotation_around_point = 20
var distance_from_point = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = rotation_point
	global_position += Vector2(cos(rotation_around_point), sin(rotation_around_point)) * distance_from_point
