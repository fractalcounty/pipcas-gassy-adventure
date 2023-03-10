extends RigidBody2D

@export var kick_force : Vector2 = Vector2(75, 100)
@export var collision_sound : RandomAudioPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
#	for i in get_colliding_bodies():
#		var col = get_slide_collision(i)
#		if col.get_collider().is_in_group("phys_objects"):
#			print ("pushing")
#			col.get_collider().apply_central_impulse(col.get_normal() * -push_force)


func _on_body_entered(body: Object) -> void:
	if body is CharacterBody2D:
		print ("body entered")
		var kick_direction : Vector2 = (position - body.position)
		apply_central_impulse(kick_direction * -kick_force)
	if body is TileMap:
		print ("ground collide")
	
	
	
	var collision_sound = target.fart_sounds
	fart_sound.play()
	fart_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
