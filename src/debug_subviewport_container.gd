extends SubViewportContainer

func _ready():
	Events.debug_subviewport_container_ready.emit(self)
