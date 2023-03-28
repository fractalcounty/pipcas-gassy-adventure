extends AnimatedSprite2D


func _init():
	set_autoplay("default")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func do_thing(sprite: AnimatedSprite2D) -> void:
	self.sprite_frames = sprite.sprite_frames
	self.offset = sprite.offset
	self.animation = sprite.animation
	self.frame = sprite.frame
	self.speed_scale = sprite.speed_scale
	self.flip_h = sprite.flip_h
