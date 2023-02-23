extends Control

@export var anim : AnimationPlayer

@export var level_title : Label
@export var level_subtitle : Label

func _ready() -> void:
	Events.flash_banner.connect(_flash_banner)

func _flash_banner(banner_title, banner_subtitle) -> void:
	#print ("Got banner thing")
	level_title.set_text(banner_title)
	level_subtitle.set_text(banner_subtitle)
	show()
	anim.play("ease_in")
