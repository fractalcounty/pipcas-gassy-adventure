extends Button

@onready var select : AudioStreamPlayer = $SelectSound
var just_opened : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_focus_entered() -> void:
	if just_opened == false:
		select.play()
