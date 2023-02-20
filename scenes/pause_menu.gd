extends Control


@export var _start_position: Vector2 = Vector2(0, -20)
@export var _end_position: Vector2 = Vector2.ZERO
@export var fade_in_duration: float = 0.3
@export var fade_out_duration: float = 0.2

@onready var center_cont = $ColorRect/CenterContainer
@onready var resume_button = center_cont.get_node(^"VBoxContainer/ResumeButton")

@onready var root = get_tree().get_root()
@onready var scene_root = root.get_child(root.get_child_count() - 1)
#@onready var tween = get_tree().create_tween()

@onready var pause : AudioStreamPlayer = $Pause
@onready var unpause : AudioStreamPlayer = $Unpause

func _ready():
	hide()


func close():
	get_tree().paused = false
	unpause.play()
	hide()
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "modulate:a",
			#1.0, fade_out_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	#tween.tween_property(center_cont, "position",
			#_end_position, fade_out_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func open():
	#var tween = get_tree().create_tween()
	pause.play()
	show()
	resume_button.grab_focus()
	#tween.tween_property(self, "modulate:a", 1.0,
			#fade_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	#tween.tween_property(center_cont, "position",
			#_end_position, fade_in_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_Tween_all_completed():
	if modulate.a < 0.5:
		hide()

func _on_resume_button_pressed() -> void:
	print ("Resume")
	#if not tween.is_active():
	close()

func _on_quit_button_pressed() -> void:
	print ("Quit")
	#scene_root.notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
