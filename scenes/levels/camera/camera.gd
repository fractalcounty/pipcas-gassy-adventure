extends Camera2D

@export_category("Pipca Camera Settings")

@export_subgroup("Mouse Movement")
@export var mouse_movement : bool
@export var mouse_sensitivity : float = 5.0
@export var mouse_follow_speed : float = 0.1

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
@onready var actual_cam_pos : Vector2 = global_position
@onready var zoom_timer : float = zoom_reset_timer

@onready var game_size : Vector2i = DisplayServer.window_get_size()
@onready var window_scale : float = (DisplayServer.window_get_size() / game_size).x

@onready var _viewport = get_viewport()

var _pipca : Pipca
var _mouse_pos : Vector2 
var _target_pos : Vector2

func _ready() -> void:
	set_physics_process(false)
	Events.pipca_spawned.connect(_on_pipca_spawned)
	reset_zoom()

func _on_pipca_spawned(pipca) -> void:
	_pipca = pipca
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	print ("running process")
	if !mouse_movement:
		_tracking_physics(delta)
	else:
		_mouse_tracking_physics(delta)

func _mouse_tracking_physics(delta) -> void:
	_mouse_pos = _viewport.get_mouse_position()
	_target_pos = _pipca.global_position
	var _mouse_offset : Vector2 = (_mouse_pos - _viewport.size * 0.5) * mouse_sensitivity
	var _target_camera_pos : Vector2 = _target_pos + _mouse_offset
	global_position = global_position.lerp(_target_camera_pos, mouse_follow_speed * delta)

func _tracking_physics(delta) -> void:
	if Global.pipca != null:
		var mixed_pos = Global.pipca.global_position + global_offset
		var cam_pos : Vector2 = lerp(Global.pipca.global_position, mixed_pos, cam_follow_lerp_weight)
		actual_cam_pos = actual_cam_pos.lerp(cam_pos, delta*cam_follow_lerp_multiplier)
		global_position = actual_cam_pos
	
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
	zoom_level = zoom_default
	print ("reseting zoom level")
	var tween: Tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", Vector2(zoom_level, zoom_level), zoom_reset_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished
	zoom_timer = zoom_reset_timer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in") && only_once:
		_set_zoom(zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out") && only_once:
		_set_zoom(zoom_level + zoom_factor)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		_mouse_pos += event.relative
		_mouse_pos = _mouse_pos.clamp(Vector2.ZERO, _viewport.size)
