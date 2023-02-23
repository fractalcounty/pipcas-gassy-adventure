extends Control

@export var resume_button : Button
@export var pause_sound : AudioStreamPlayer
@export var unpause_sound : AudioStreamPlayer
@export var select_sound : AudioStreamPlayer

var just_opened : bool

func _ready():
	hide()

func _on_pause_menu_open():
	just_opened = true
	pause_sound.play()
	show()
	resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	just_opened = true
	unpause_sound.play()
	hide()
	get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_resume_button_focus_entered() -> void:
	if just_opened == false:
		select_sound.play()

func _on_quit_button_focus_entered() -> void:
	just_opened = false
	select_sound.play()
