extends Camera2D

@export_node_path var pipca_path
@onready var pipca = get_node(pipca_path)

@onready var global_offset : Vector2
@export var base_offset : Vector2

var game_size := Vector2(640,360)
var window_size : Vector2
var window_scale : float
var mouse_moving = false
@onready var actual_cam_pos := global_position

	
