extends Camera2D

@export var gofset : Vector2
var target : Vector2
# - 60 is good

#var game_size := Vector2(640,360)
#@onready var window_size : Vector2 = DisplayServer.window_get_size(0)
#@onready var window_scale : float
#@onready var actual_cam_pos := global_position

func _ready() -> void:
	pass
#	set_physics_process(false)
#	Events.follow_origin.connect(_on_follow_origin)
#
#func _on_follow_origin(pos) -> void:
#	target = pos
#	set_physics_process(true)
#
#func _physics_process(delta: float) -> void:
#	position = target + gofset
#	print (target)
