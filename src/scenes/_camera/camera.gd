extends Camera2D

@export_category("Player Camera Settings")

@export var shaker : Shaker

@export_subgroup("Freelook")
@export var freelook_distance : float = 0.8
@export var freelook_lerp : float = 5.0

@export_subgroup("Tracking")
@export var cam_follow_lerp_weight : float = 0.5
@export var cam_follow_lerp_multiplier : float = 40

@export_subgroup("Zoom")
@export var zoom_default : float = 2.0
@export var zoom_min : float = 1.0
@export var zoom_max : float = 4.0
@export var zoom_reset_timer : float = 3.0
@export var zoom_reset_speed : float = 1.0
@export var zoom_factor : float = 0.25
@export var zoom_duration : float = 0.25

@export var global_offset : Vector2
@onready var only_once : bool = true
@onready var zoom_level : float = 3.0: set = _set_zoom
@onready var zoom_timer : float = zoom_reset_timer

@onready var _viewport = get_viewport()
@onready var _game_size : Vector2 = Vector2(640,360)
@onready var _window_size : Vector2 = DisplayServer.window_get_size()
@onready var _window_scale : float = (_window_size / _game_size).x
@onready var _actual_cam_pos : Vector2 = global_position
@onready var _player : Player
@onready var _mouse_pos : Vector2 
@onready var _target_pos : Vector2
@onready var mouse_movement : bool = false
@onready var _initial_window_size : Vector2 = DisplayServer.window_get_size()



var player_spawned : bool = false

func shake(time) -> void:
	shaker.start(time)

func _ready() -> void:
	Global.subviewport.size_changed.connect(_on_viewport_size_changed)
	set_physics_process(false)
	Events.player_spawned.connect(_on_player_spawned)
	Global.camera = self

func _on_player_spawned(player) -> void:
	_player = player
	player_spawned = true
	set_physics_process(true)
	reset_zoom()

func _physics_process(delta: float) -> void:
	#print(timer.time_left)
	if !mouse_movement:
		_tracking_physics(delta)
	else:
		_freelook_physics(delta)

func _on_viewport_size_changed() -> void:
	if player_spawned:
		print ("Viewport size changed")
		reset_zoom()

func _freelook_physics(delta) -> void:
	_mouse_pos = _viewport.get_mouse_position() / _window_scale - (_game_size/3) + _player.global_position + global_offset
	var _cam_pos = lerp(_player.global_position, _mouse_pos, freelook_distance)
	_actual_cam_pos = lerp(_actual_cam_pos, _cam_pos, delta * freelook_lerp)
	global_position = _actual_cam_pos
	
	if zoom_level != zoom_default:
		_zoom_timer(delta)

func _tracking_physics(delta) -> void:
	var mixed_pos = Global.player.global_position + global_offset
	var cam_pos : Vector2 = lerp(Global.player.global_position, mixed_pos, cam_follow_lerp_weight)
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
	_mouse_pos = _player.global_position
	var current_window_size : Vector2 = DisplayServer.window_get_size()
	
	# Calculate the scale factor based on the current window size and the game's rendered resolution (1280x720)
	var scale_factor : float = min(current_window_size.x / 640, current_window_size.y / 360)
	
	# Calculate the zoom level based on the initial zoom level and the scale factor
	zoom_level = zoom_default * scale_factor

	print ("[Camera] Reseting zoom level")
	var tween: Tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", Vector2(zoom_level, zoom_level), zoom_reset_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished
	zoom_timer = zoom_reset_timer

func _exit_tree():
	Global.camera = null
