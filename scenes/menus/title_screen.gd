extends Control

@export var play_button : Button
@export var settings_button : Button
@export var quit_button : Button

@onready var already_pressed : bool = false

func _ready():
	play_button.grab_focus()

func _input(event) -> void:
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
		print ("input")
		UIAudio.click.play()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

#func _process(delta: float) -> void:
#	if moving:
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	else:
#		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	if !already_pressed:
		get_parent().load_level()
		already_pressed = true

func _on_play_button_mouse_entered() -> void:
	UIAudio.click.play()

func _on_settings_button_mouse_entered() -> void:
	UIAudio.click.play()


func _on_quit_button_mouse_entered() -> void:
	UIAudio.click.play()


func _on_play_button_button_up() -> void:
	UIAudio.unclick.play()


func _on_settings_button_button_up() -> void:
	UIAudio.unclick.play()


func _on_quit_button_button_up() -> void:
	UIAudio.unclick.play()
