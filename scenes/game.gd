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
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_viewport().set_input_as_handled()
