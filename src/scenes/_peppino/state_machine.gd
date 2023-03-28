#state_machine.gd
class_name StateMachine
extends Node2D

signal transitioned(state_name)

@export var initial_state : NodePath = NodePath()
@export var animation_player : AnimationPlayer

@onready var state: State = get_node(initial_state)
@onready var last_state : State

var state_timers : Dictionary = {}

func _ready() -> void:
	animation_player.animation_finished.connect(_anim_finished)
	
	await owner.ready
	for child in get_children():
		child.state_machine = self
	state.enter()
		
func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _anim_finished(name: StringName) -> void:
	print (name)
	state.anim_finished(name)


## Helper functions

func last_state_was(target_state_name: String) -> bool:
	var target_state_name_pascal : String = target_state_name.to_pascal_case()
	var case_error : String = "[StateMachine] Last state '" + str(target_state_name) + "' must be in snake_case format"
	var regex : RegEx = RegEx.new()
	regex.compile("^([a-z]+[a-z0-9]*(_[a-z0-9]+)*_?)$")
	assert(regex.search(target_state_name) != null, case_error)
	
	return last_state != null and last_state.name == target_state_name_pascal

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	var target_state_name_pascal : String = target_state_name.to_pascal_case()
	var target_state_name_snake : String = target_state_name.to_snake_case()
	var generic_error : String = "[StateMachine] Invalid transition to " + str(target_state_name_pascal)
	var case_error : String = "[StateMachine] Target state '" + str(target_state_name) + "' must be in snake_case format, i.e: '" + str(target_state_name_snake) + "'"
	var valid : bool = true
	
	var regex : RegEx = RegEx.new()
	regex.compile("^([a-z]+[a-z0-9]*(_[a-z0-9]+)*_?)$")
	assert(regex.search(target_state_name) != null, case_error)
	
	if not has_node(target_state_name_pascal):
		assert(valid, generic_error)

	state.exit()
	last_state = state
	state = get_node(target_state_name_pascal)

		#prints("[StateMachine]", last_state, "=>", target_state_name_pascal)
	if Global.debug.state_label_instance != null:
		Global.debug.state_label_instance.set_text(str(target_state_name_pascal))
	
	state.enter(msg)
	emit_signal("transitioned", state.name)
