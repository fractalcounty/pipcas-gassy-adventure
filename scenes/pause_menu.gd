extends Control

@export var time_cooldown : float

@export_group("Anatomy")
@export var resume_button : Button
@export var quit_button : Button
@export var color_rect : ColorRect
@export var timer : Timer

@export_group("Tween")
@export var active_color : Color
@export var inactive_color : Color
@export_exp_easing("positive_only") var transition_speed : float

var just_opened : bool

func _ready() -> void:
	Events.pause_opened.emit()
	hide()
	timer.stop()
	timer.one_shot = true

func _input(event: InputEvent) -> void:
	if is_visible_in_tree():
		if event is InputEventMouseMotion:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			UIAudio.click.play()

func _unhandled_input(event: InputEvent) -> void:
	if is_visible_in_tree():
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			resume_button.grab_focus()

func on_pause_open() -> void:
	timer.start(time_cooldown)
	var tween = get_tree().create_tween()
	self.modulate.a = 0
	color_rect.color = inactive_color
	show()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)
	tween.tween_property(color_rect, "color", active_color, transition_speed*1.5)
	tween.tween_property(self, "modulate:a", 1, transition_speed*1.5)
	tween.set_trans(Tween.TRANS_SINE)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	await tween.finished
	Global.game_state = Global.state.PAUSE
	resume_button.disabled = false
	quit_button.disabled = false
	just_opened = true

func on_pause_close() -> void:
	Events.pause_closed.emit()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color", inactive_color, transition_speed)
	tween.tween_property(self, "modulate:a", 0, transition_speed)
	tween.set_trans(Tween.TRANS_SINE)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	just_opened = true
	resume_button.disabled = true
	quit_button.disabled = true
	await tween.finished
	if Global.game_state == Global.state.PAUSE:
		Global.game_state = Global.state.GAME
	queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	hide()
	queue_free()

func _on_resume_button_pressed() -> void:
	on_pause_close()

func _on_quit_button_pressed() -> void:
	get_parent().return_to_menu()

func _on_resume_button_mouse_entered() -> void:
	if timer.is_stopped():
		UIAudio.click.play()
	resume_button.release_focus()
	quit_button.release_focus()

func _on_quit_button_mouse_entered() -> void:
	if timer.is_stopped():
		UIAudio.click.play()
	quit_button.release_focus()
	resume_button.release_focus()

func _on_resume_button_mouse_exited() -> void:
	quit_button.release_focus()
	resume_button.release_focus()

func _on_quit_button_mouse_exited() -> void:
	quit_button.release_focus()
	resume_button.release_focus()

func _on_resume_button_button_down() -> void:
	pass

func _on_resume_button_button_up() -> void:
	UIAudio.unclick.play()
