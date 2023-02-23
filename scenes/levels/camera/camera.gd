extends Camera2D

@export_category("Pipca Camera Settings")
@export var pipca : Pipca

@export_subgroup("Grounded")
@export var grounded_offset : Vector2
@export var grounded_lerp_weight : float = 0.7
@export var grounded_lerp_multiplier : float = 0.5

@export_subgroup("Air")
@export var air_offset : Vector2
@export var air_lerp_weight : float = 0.7
@export var air_lerp_multiplier : float = 0.5

@export_subgroup("Cutscenes")
@export var cutscene_offset : Vector2

@export_subgroup("Zoom")
@export var min_zoom := 0.5
@export var max_zoom := 2.0
@export var zoom_factor := 0.1
@export var zoom_duration := 0.2
@onready var tween: Tween

var game_size := Vector2(640,360)
var window_size : Vector2
var window_scale : float
var mouse_moving = false
var zoom_level := 1.0: set = _set_zoom_level
var actual_cam_pos := global_position

func _physics_process(delta: float) -> void:
	if Global.is_grounded:
		ground_cam(delta)
	else:
		air_cam(delta)

func ground_cam(delta: float) -> void:
	var zoom_mult : float = zoom_level * -10
	var zoom_fixed : float = -remap(zoom_mult, -6.5, -10, 145.0, 0.0)
	var added_offset : Vector2 = Vector2(0, (grounded_offset.y + zoom_fixed))
	var final_offset : Vector2 = grounded_offset + added_offset
	
	var mixed_pos = pipca.global_position + added_offset
	
	var cam_pos : Vector2 = lerp(pipca.global_position, mixed_pos, grounded_lerp_weight)
	
	actual_cam_pos = actual_cam_pos.lerp(cam_pos, delta*grounded_lerp_multiplier)
	
	var subpixel_position = actual_cam_pos.round() - actual_cam_pos
	
	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
	
	var paramer = Global.viewport_container.material.get_shader_parameter("cam_offset")
	
	print (paramer)
	
	global_position = actual_cam_pos.round()

func air_cam(delta: float) -> void:
	var mixed_pos = pipca.global_position + air_offset
	var cam_pos : Vector2 = lerp(pipca.global_position, mixed_pos, air_lerp_weight)
	actual_cam_pos = actual_cam_pos.lerp(cam_pos, delta*air_lerp_multiplier)
	var subpixel_position = actual_cam_pos.round() - actual_cam_pos
	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
	global_position = actual_cam_pos.round()
	
func _set_zoom_level(value: float) -> void:
	zoom_level = clamp(value, min_zoom, max_zoom)
	tween = get_tree().create_tween()
	tween.tween_property(
		self,
		"zoom",
		Vector2(zoom_level, zoom_level),
		zoom_duration)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		_set_zoom_level(zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(zoom_level + zoom_factor)
