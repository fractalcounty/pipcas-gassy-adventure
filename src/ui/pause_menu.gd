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

@onready var open : bool = false

var just_opened : bool

func _ready() -> void:
	Events.pause_opened.emit()
	timer.stop()
	timer.one_shot = true

func _input(event: InputEvent) -> void:
	if is_visible_in_tree() and open:
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
	Global.game_state = Global.state.PAUSE
	timer.start(time_cooldown)
	color_rect.color = inactive_color
	var tween = self.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)
	tween.tween_property(color_rect, "color", active_color, transition_speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "modulate:a", 1, transition_speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	await tween.finished
	resume_button.disabled = false
	quit_button.disabled = false
	just_opened = true
	open = true

func on_pause_close() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	Events.pause_closed.emit()
	var tween = self.create_tween()
	open = false
	Global.game_state = Global.state.GAME
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "modulate", inactive_color, transition_speed)
	tween.tween_property(self, "modulate:a", 0, transition_speed)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	await tween.finished
	just_opened = true
	resume_button.disabled = true
	quit_button.disabled = true
	await tween.finished
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
