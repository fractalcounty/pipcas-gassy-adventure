extends Node

@onready var _pause_menu = $PauseMenu

func _ready():
	Global.viewport_container = $SubViewportContainer
	Global.viewport = $SubViewportContainer/SubViewport
	

func _unhandled_input(event):
	if event.is_action_pressed("in_pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu._on_pause_menu_open()
		else:
			_pause_menu._on_resume_button_pressed()
		get_viewport().set_input_as_handled()
	
	var velocity = Input.get_vector("look_up", "look_down", "look_left", "look_right")

	if event is InputEventMouseMotion:
		Global.mouse_moving = true
		Global.joy_moving = false

	if velocity != Vector2(0, 0):
		Global.mouse_moving = false
		Global.joy_moving = true
	else:
		Global.joy_moving = false


func _input(event: InputEvent) -> void:
	var velocity = Input.get_vector("look_up", "look_down", "look_left", "look_right")

	if event is InputEventMouseMotion:
		Global.mouse_moving = true
		Global.joy_moving = false

	if velocity != Vector2(0, 0):
		Global.mouse_moving = false
		Global.joy_moving = true
	else:
		Global.joy_moving = false
