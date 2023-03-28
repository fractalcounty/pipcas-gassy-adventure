# Virtual base class for all states.
class_name State
extends Node2D

# Reference to the state machine, to call its `transition_to()` method directly.
# That's one unorthodox detail of our state implementation, as it adds a dependency between the
# state and the state machine objects, but we found it to be most efficient for our needs.
# The state machine node will set it.
var state_machine = null

@export var timer_duration : float = 0.0
@export var timer_autostart : bool = false

var timer : Timer = Timer.new()

func _init():
	timer.set_name("state_timer")
	add_child(timer)
	timer.timeout.connect(_on_timer_end)

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	timer.stop()

func anim_finished(_name: StringName) -> void:
	pass

func on_timer_end() -> void:
	pass

func _on_timer_end() -> void:
	on_timer_end()

func start_timer(duration: float = -1.0) -> void:
	var actual_duration : float = duration if duration >= 0.0 else timer_duration
	if actual_duration > 0.0:
		timer.start(actual_duration)

func stop_timer() -> void:
	timer.stop()

func get_timer_duration() -> float:
	if timer.is_stopped():
		return 0.0
	return timer.time_left
