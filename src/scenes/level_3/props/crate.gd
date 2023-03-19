extends RigidBody2D

@export var kick_force : Vector2 = Vector2(75, 100)

@export var ground_sound : AudioStreamPlayer2D
@export var kick_sound : AudioStreamPlayer2D
var cooldown : bool = false

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
		#print ("body entered")
		#kick_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
		var kick_direction : Vector2 = (position - body.position)
		apply_central_impulse(kick_direction * -kick_force)
		if !cooldown:
			kick_sound.play()
			cooldown = true
			await get_tree().create_timer(0.25).timeout
			cooldown = false

	if body is TileMap:
		if !cooldown:
			#print ("ground collide")
			ground_sound.play()
			ground_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
			cooldown = true
			await get_tree().create_timer(0.25).timeout
			cooldown = false
