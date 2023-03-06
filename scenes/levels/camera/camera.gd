extends Camera2D

@export_category("Pipca Camera Settings")
@export var pipca : CharacterBody2D
@export var remote_transform : RemoteTransform2D

@export_subgroup("Grounded")
@export var grounded_offset : Vector2
@export var grounded_lerp_weight : float = 0.7
@export var grounded_lerp_multiplier : float = 0.5

@export_subgroup("Air")
@export var air_offset : Vector2
@export var air_lerp_weight : float = 0.7
@export var air_lerp_multiplier : float = 0.5

@export_subgroup("Zoom")
@onready var zoom_default : Vector2 = Vector2(zoom_max, zoom_max)
@export var zoom_min := 3.0
@export var zoom_max := 6.0
@export var zoom_reset_time : float = 5.0
@export var zoom_reset_speed : float = 0.5
@export var zoom_factor := 0.1
@export var zoom_duration := 0.2

@onready var global_offset : Vector2
#@onready var tween: Tween

var game_size := Vector2(640,360)
var window_size : Vector2
var window_scale : float
var mouse_moving = false
var zoom_level := 4.0: set = _set_zoom_level
var actual_cam_pos := global_position
var zoom_timer := zoom_reset_time


@onready var only_once : bool = true

var last_zoom : float = zoom_level
var enable_timer : bool = false

func _ready() -> void:
	Global.camera = self
	only_once = true

func _physics_process(delta: float) -> void:
	
	if Global.pipca != null:
		if Global.is_grounded:
			ground_cam(delta)
		else:
			air_cam(delta)
	print(zoom_level)
	
	if zoom_level != zoom_max:
		_zoom_timer(delta)
	
func _zoom_timer(delta) -> void:	
	zoom_timer -= delta
	if zoom_timer <= 0.0:
		_reset_zoom_level()

func ground_cam(delta: float) -> void:
	var mixed_pos = Global.pipca.global_position + global_offset
	var cam_pos : Vector2 = lerp(Global.pipca.global_position, mixed_pos, grounded_lerp_weight)
	actual_cam_pos = actual_cam_pos.lerp(cam_pos, delta*grounded_lerp_multiplier)
	global_position = actual_cam_pos

func air_cam(delta: float) -> void:
	var mixed_pos = Global.pipca.global_position + air_offset + global_offset
	var cam_pos : Vector2 = lerp(Global.pipca.global_position, mixed_pos, air_lerp_weight)
	actual_cam_pos = actual_cam_pos.lerp(cam_pos, delta*air_lerp_multiplier)
	global_position = actual_cam_pos
	
func _set_zoom_level(value: float) -> void:
	zoom_timer = zoom_reset_time
	only_once = false
	zoom_level =  clamp(value, zoom_min, zoom_max)
	var tween : Tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", Vector2(zoom_level, zoom_level), zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	only_once = true

func _reset_zoom_level() -> void:
	zoom_level = zoom_max
	zoom_timer = zoom_reset_time
	print ("reseting zoom level")
	var tween: Tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", zoom_default, zoom_reset_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).finished

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in") && only_once:
		_set_zoom_level(zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out") && only_once:
		_set_zoom_level(zoom_level + zoom_factor)
