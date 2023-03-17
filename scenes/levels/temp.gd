extends AnimationPlayer

func _on_cutscene_1_body_entered(body: Node2D) -> void:
	print ("playing")
	play("cado")
