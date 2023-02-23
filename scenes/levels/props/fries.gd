extends AnimatedSprite2D

@export var eat_sound : AudioStreamPlayer
@export var anim : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	anim.play("eat")

func dissapear() -> void:
	self.queue_free()
