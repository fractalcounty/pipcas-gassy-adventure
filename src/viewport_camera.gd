extends Camera2D

var remote_transform : RemoteTransform2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.viewport_camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
