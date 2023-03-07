extends Node

@export var skip : bool = false

@export var subviewport_container : SubViewportContainer
@export var subviewport : SubViewport
@export var intro : VideoStreamPlayer
@export var title_screen : Control
@export var pause_menu : Control
@export var game_scene : Control

var arrow = load("res://assets/menus/arrow.png")
var pointing = load("res://assets/menus/grabber.png")

func _ready():
	get_tree().root.title = "Pipca's Gassy Adventure"
	
	if skip:
		load_level()
	else:
		load_intro()

func load_intro():
	Global.game_state = Global.state.INTRO
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	intro.show()

func _on_intro_finished() -> void:
	intro.queue_free()
	load_title_screen()

func load_title_screen():
	get_viewport().set_input_as_handled()
	Input.set_custom_mouse_cursor(arrow)
	Input.set_custom_mouse_cursor(pointing, Input.CURSOR_POINTING_HAND)
	Global.game_state = Global.state.MENU
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	title_screen.show()

func load_level() -> void:
	Global.game_state = Global.state.GAME
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	title_screen.queue_free()
	
	var scene = preload("res://scenes/levels/level.tscn")
	var instance = scene.instantiate()
	subviewport.add_child(instance)
	#spawn_pipca()


#func get_transform() -> void:
#	if Global.remote_transform == null:
#		push_error("FUCK")
#	else:
#		remote_transform = Global.transform

#func spawn_pipca() -> void:
#	print ("Spawning Pipca...")
#	var scene = preload("res://scenes/pipca/pipca.tscn")
#	var instance = scene.instantiate()
#	add_child(instance)
#
#	var level = game_scene.get_node_or_null("level")
#	var spawn = level.get_node_or_null("Spawn")
#
#	spawn.on_pipca_spawn()
#
#	viewport_container.show()
#	print ("Pipca spawned! Pipca win!...")

func _unhandled_input(event):
	if Global.game_state == Global.state.MENU:
		title_screen.focus_mode = Control.FOCUS_ALL
	
	if event.is_action_pressed("in_pause"):
		if Global.game_state == Global.state.INTRO:
			_on_intro_finished()
		if Global.game_state == Global.state.GAME:
			var tree = get_tree()
			tree.paused = not tree.paused
			if tree.paused:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				pause_menu._on_pause_menu_open()
			else:
				pause_menu._on_resume_button_pressed()
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
			get_viewport().set_input_as_handled()

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
