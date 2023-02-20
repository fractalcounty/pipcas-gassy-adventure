extends Node2D
@onready var footsteps : RandomAudioPlayer = $Footsteps
@onready var belch : AudioStreamPlayer = $Belch

func play():
	footsteps.play()

func play_belch():
	belch.play()
	
