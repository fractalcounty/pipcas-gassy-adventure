extends Node

@export_category("Game")
@export var level : PackedScene
@export var pipca : PackedScene
@export var subviewport_container : SubViewportContainer
@export var subviewport : SubViewport

@export_category("UI")
@export var skip_intro : bool = false
@export var intro : VideoStreamPlayer
@export var pause_menu : PackedScene
@export var title_screen : PackedScene
@export var level_banner : PackedScene
@export var counter : PackedScene

@export var transition_player : AnimationPlayer

@onready var arrow = load("res://assets/menus/arrow.png")
@onready var pointing = load("res://assets/menus/grabber.png")

@onready var pause_menu_instance : Control = null
@onready var level_instance : Node2D = null
@onready var level_banner_instance : Control = null
@onready var pipca_instance : Node2D = null
@onready var title_screen_instance : Control = null
@onready var trans_in_progress : bool = false
@onready var counter_instance : Control = null


func _ready():
	set_process(false)
	get_tree().root.title = "Pipca's Gassy Adventure"
	
	if skip_intro:
		load_level()
	else:
		_load_intro()

func _load_intro():
	Global.game_state = Global.state.INTRO
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	intro.paused = false
	intro.show()

func _on_intro_finished() -> void:
	_load_title_screen()
	intro.queue_free()

func _load_title_screen():
	Global.game_state == Global.state.MENU
	
	set_process(false)
	
	Global.subviewport = subviewport
	
	title_screen_instance = title_screen.instantiate()
	add_child(title_screen_instance)
	
	await is_instance_valid(title_screen_instance)
	Global.game_state = Global.state.MENU
	
	Input.set_custom_mouse_cursor(arrow)
	Input.set_custom_mouse_cursor(pointing, Input.CURSOR_POINTING_HAND)
	title_screen_instance.show()

func load_level() -> void:
	Global.game_state = Global.state.GAME
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	trans_in_progress = true
	transition_player.play("fade_in")
	await transition_player.animation_finished
	title_screen_instance.queue_free()
	
	level_instance = level.instantiate()
	subviewport.add_child(level_instance)
	
	await is_instance_valid(level_instance)
	
	_spawn_pipca(level_instance)

func _spawn_pipca(level_instance) -> void:
	pipca_instance = pipca.instantiate()
	level_instance.add_child(pipca_instance)
	await is_instance_valid(pipca_instance)
	_load_counter(level_instance)
	
func _load_counter(level_instance) -> void:
	counter_instance = counter.instantiate()
	add_child(counter_instance)
	await is_instance_valid(counter_instance)
	Global.counter = counter_instance
	_load_banner(level_instance)

func _load_banner(level_instance) -> void:
	level_banner_instance = level_banner.instantiate()
	add_child(level_banner_instance)
	await is_instance_valid(level_banner_instance)
	Events.flash_banner.emit(level_instance.banner_title, level_instance.banner_subtitle)
	transition_player.play_backwards("fade_in")
	set_process(true)
	await transition_player.animation_finished
	trans_in_progress = false

func _load_pause_menu():
	UIAudio.double_click.play()
	if Global.game_state == Global.state.GAME:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pause_menu_instance = pause_menu.instantiate()
		add_child(pause_menu_instance)

func _process(delta: float) -> void:
	if Global.game_state == Global.state.PAUSE:
		level_instance.get_tree().paused = true
	else:
		level_instance.get_tree().paused = false
	
func return_to_menu() -> void:
	transition_player.play("fade_in")
	await transition_player.animation_finished
	if is_instance_valid(level_banner_instance):
		level_banner_instance.queue_free()
	level_instance.queue_free()
	if is_instance_valid(counter_instance):
		counter_instance.queue_free()
	if is_instance_valid(pause_menu_instance):
		pause_menu_instance.on_pause_close()
	_load_title_screen()
	transition_player.play_backwards("fade_in")

func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Global.game_state == Global.state.INTRO:
			_on_intro_finished()
		if Global.game_state == Global.state.GAME:
			_load_pause_menu()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_menu_instance.on_pause_open()
			get_viewport().set_input_as_handled()
		if Global.game_state == Global.state.PAUSE:
			UIAudio.unclick.play()
			pause_menu_instance.on_pause_close()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Global.game_state == Global.state.GAME and is_instance_valid(pipca_instance):
		if event.is_action_pressed("in_look"):
			Global.camera.mouse_movement = true
		if event.is_action_released("in_look"):
			Global.camera.mouse_movement = false
		if event.is_action_pressed("zoom_in") && Global.camera.only_once:
			Global.camera._set_zoom(Global.camera.zoom_level - Global.camera.zoom_factor)
		if event.is_action_pressed("zoom_out") && Global.camera.only_once:
			Global.camera._set_zoom(Global.camera.zoom_level + Global.camera.zoom_factor)

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
