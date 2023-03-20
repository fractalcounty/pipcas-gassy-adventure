extends Node2D
class_name PointsLabel

var _value : float = 0.0
var _startpos : Vector2 = Vector2.ZERO
var _endpos : Vector2 = Vector2.ZERO
var _move_speed : float = 0.0
var _shrink_delay : float = 0.0
var _shrink_speed : float = 0.0
var _timed_out : bool = false

func _ready() -> void:
	$Label/Timer.timeout.connect(_on_timer_timeout)
	_timed_out = false

func init(value: float, move_speed: float, shrink_delay: float, shrink_speed : float, startpos: Vector2, endpos: Vector2) -> void:
	_value = value
	_move_speed = move_speed
	_shrink_delay = shrink_delay
	_shrink_speed = shrink_speed
	_startpos = startpos
	_endpos = endpos
	
	if _value == 0:
		push_error("[PointsLabel] Instantiated with empty points value, ensure that the collectible has an assigned points value.")
		queue_free()
	if (_move_speed == 0 or _shrink_delay == 0 or _shrink_speed == 0):
		push_error("[PointsLabel] Instantiated with empty speed/shrink values, aborting.")
		queue_free()
	if _startpos == Vector2.ZERO or _endpos == Vector2.ZERO:
		push_error("[PointsLabel] Instantiated with empty vectors, aborting.")
		queue_free()
	else:
		$Label.text = str(_value)
		global_position = _startpos
		$Label/Timer.start(_shrink_delay)
		$Label.position = $Label.size / 2

func _physics_process(delta: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", _endpos, _move_speed*delta)
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	if _timed_out:
		tween.set_parallel(true)
		tween.tween_property(self, "scale", Vector2(0, 0), _shrink_speed*delta)
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	if scale == Vector2.ZERO:
		queue_free()

func _on_timer_timeout() -> void:
		print ("[PointsLabel] Timer stopped.")
		_timed_out = true
