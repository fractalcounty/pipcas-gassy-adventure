extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	var velocity = Input.get_vector("joy_up", "joy_down", "joy_left", "joy_right")

	if event is InputEventMouseMotion:
		Global.mouse_moving = true
		Global.joy_moving = false
	#if event is InputEvent
	

	if velocity != Vector2(0, 0):
		Global.mouse_moving = false
		Global.joy_moving = true
	else:
		Global.joy_moving = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#Global.mouse_moving = false
	#print (Global.mouse_moving)
