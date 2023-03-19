extends Camera2D

@export_category("Pipca Camera Settings")

@export_subgroup("Freelook")
@export var freelook_distance : float = 0.7
@export var freelook_lerp : float = 0.5

@export_subgroup("Tracking")
@export var cam_follow_lerp_weight : float = 0.7
@export var cam_follow_lerp_multiplier : float = 0.5

@export_subgroup("Zoom")
@export var zoom_default : float = 4.0
@export var zoom_min : float = 3.0
@export var zoom_max : float = 4.0
@export var zoom_reset_timer : float = 5.0
@export var zoom_reset_speed : float = 0.5
@export var zoom_factor : float = 0.1
@export var zoom_duration : float = 0.2

@onready var global_offset : Vector2
@onready var only_once : bool = true
@onready var zoom_level : float = 3.0: set = _set_zoom
@onready var zoom_timer : float = zoom_reset_timer

@onready var _viewport = get_viewport()
@onready var _game_size : Vector2 = Vector2(640,360)
@onready var _window_size : Vector2 = DisplayServer.window_get_size()
@onready var _window_scale : float = (_window_size / _game_size).x
@onready var _actual_cam_pos : Vector2 = global_position
@onready var _pipca : Pipca
@onready var _mouse_pos : Vector2 
@onready var _target_pos : Vector2
@onready var mouse_movement : bool = false

func _ready() -> void:
	set_physics_process(false)
	Events.pipca_spawned.connect(_on_pipca_spawned)
	Global.camera = self

func _on_pipca_spawned(pipca) -> void:
	_pipca = pipca
	set_physics_process(true)
	reset_zoom()

func _physics_process(delta: float) -> void:
	#print(timer.time_left)
	if !mouse_movement:
		_tracking_physics(delta)
	else:
		_freelook_physics(delta)

func _freelook_physics(delta) -> void:
	_mouse_pos = _viewport.get_mouse_position() / _window_scale - (_game_size/3) + _pipca.global_position + global_offset
	var _cam_pos = lerp(_pipca.global_position, _mouse_pos, freelook_distance)
	_actual_cam_pos = lerp(_actual_cam_pos, _cam_pos, delta * freelook_lerp)
	global_position = _actual_cam_pos
	
	if zoom_level != zoom_default:
		_zoom_timer(delta)

func _tracking_physics(delta) -> void:
	var mixed_pos = Global.pipca.global_position + global_offset
	var cam_pos : Vector2 = lerp(Global.pipca.global_position, mixed_pos, cam_follow_lerp_weight)
	_actual_cam_pos = _actual_cam_pos.lerp(cam_pos, delta*cam_follow_lerp_multiplier)
	global_position = _actual_cam_pos
	
	if zoom_level != zoom_default:
		_zoom_timer(delta)

func _zoom_timer(delta) -> void:	
	zoom_timer -= delta
	if zoom_timer <= 0.0:
		reset_zoom()
	
func _set_zoom(value: float) -> void:
	only_once = false
	zoom_level =  clamp(value, zoom_min, zoom_max)
	var tween : Tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", Vector2(zoom_level, zoom_level), zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	zoom_timer = zoom_reset_timer
	only_once = true

func reset_zoom() -> void:
	_mouse_pos = _pipca.global_position
	zoom_level = zoom_default
	print ("[camera] Reseting zoom level")
	var tween: Tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", Vector2(zoom_level, zoom_level), zoom_reset_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished
	zoom_timer = zoom_reset_timer
