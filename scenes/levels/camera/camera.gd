extends Camera2D

@export_category("Pipca Camera Settings")

@export_subgroup("Tracking")
@export var cam_follow_lerp_weight : float = 0.7
@export var cam_follow_lerp_multiplier : float = 0.5

@export_subgroup("Zoom")
@onready var zoom_default : Vector2 = Vector2(zoom_max, zoom_max)
@export var zoom_min := 3.0
@export var zoom_max := 6.0
@export var zoom_reset_timer : float = 5.0
@export var zoom_reset_speed : float = 0.5
@export var zoom_factor := 0.1
@export var zoom_duration := 0.2

@onready var global_offset : Vector2
@onready var only_once : bool = true

var zoom_level := 4.0: set = _set_zoom
var actual_cam_pos := global_position
var zoom_timer := zoom_reset_timer

func _physics_process(delta: float) -> void:
	_tracking_physics(delta)

func _tracking_physics(delta) -> void:
	if Global.pipca != null:
		var mixed_pos = Global.pipca.global_position + global_offset
		var cam_pos : Vector2 = lerp(Global.pipca.global_position, mixed_pos, cam_follow_lerp_weight)
		actual_cam_pos = actual_cam_pos.lerp(cam_pos, delta*cam_follow_lerp_multiplier)
		global_position = actual_cam_pos
	
	if zoom_level != zoom_max:
		_zoom_timer(delta)

func _zoom_timer(delta) -> void:	
	zoom_timer -= delta
	if zoom_timer <= 0.0:
		reset_zoom()
	
func _set_zoom(value: float) -> void:
	zoom_timer = zoom_reset_timer
	only_once = false
	zoom_level =  clamp(value, zoom_min, zoom_max)
	var tween : Tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", Vector2(zoom_level, zoom_level), zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	only_once = true

func reset_zoom() -> void:
	zoom_level = zoom_max
	zoom_timer = zoom_reset_timer
	print ("reseting zoom level")
	var tween: Tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", zoom_default, zoom_reset_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).finished

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in") && only_once:
		_set_zoom(zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out") && only_once:
		_set_zoom(zoom_level + zoom_factor)
