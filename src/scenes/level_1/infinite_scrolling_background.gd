extends PreviewingParallaxBackground

@export var speed = 100.0

@export var direction = Vector2.DOWN

func _process(delta):

	scroll_base_offset += (speed * direction) * delta
