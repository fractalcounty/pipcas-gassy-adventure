#player_state.gd
class_name PlayerState
extends State

@onready var step_timer : float = 0.0

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "[PlayerState] Incorrect assignement, player expected")

func get_jump_params(override_state_name: String = "") -> Dictionary:
	var case_error : String = "[PlayerState] Override state name '" + str(override_state_name) + "' must be in snake_case format"
	var current_state : String = state_machine.state.name
	var state_name : String = override_state_name if not override_state_name.is_empty() else current_state.to_snake_case()
	
	if override_state_name.is_empty():
		assert(player.get(state_name + "_height"), "[" + state_name + "]" + " has no corresponding valid height variable in target script.")
		assert(player.get(state_name + "_time_to_peak"), "[PlayerState]: " + state_name + " has no valid time_to_peak variable in target script.")
		assert(player.get(state_name + "_time_to_descent"), "[PlayerState]: " + state_name + " has no corresponding valid time_to_descent variable in target script.")
	else:
		var regex : RegEx = RegEx.new()
		regex.compile("^([a-z]+[a-z0-9]*(_[a-z0-9]+)*_?)$")
		assert(regex.search(override_state_name) != null, case_error)
	
	var height = player.get(state_name + "_height")
	var time_to_peak = player.get(state_name + "_time_to_peak")
	var time_to_descent = player.get(state_name + "_time_to_descent")

	var jump_velocity = ((2.0 * height) / time_to_peak) * -1.0
	var jump_gravity = ((-2.0 * height) / (time_to_peak * time_to_peak)) * -1.0
	var fall_gravity = ((-2.0 * height) / (time_to_descent * time_to_descent)) * -1.0

	return {
		"jump_velocity": jump_velocity,
		"jump_gravity": jump_gravity,
		"fall_gravity": fall_gravity,
	}

func get_gravity(jump_params: Dictionary) -> float:
	return jump_params["jump_gravity"] if player.velocity.y < 0.0 else jump_params["fall_gravity"]

func play_step_sound(_delta: float, interval) -> void:
	step_timer += _delta
	if abs(player.velocity.x) > 0.1 and player.is_on_floor():
		if step_timer >= interval:
			step_timer = 0.0
			player.sound.step.pitch_scale = 0.9 + ( randf() - 0.2 ) / 3
			player.sound.step.play()
	else:
		step_timer = 0.0
