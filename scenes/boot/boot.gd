extends Control

const GAME_PATH : String = "res://game.tscn"

var duration : float
var expected_duration : float = 0

enum LoadingStage {LOADING, SPAWNING}
var stage := LoadingStage.LOADING

func _ready():
	ResourceLoader.load_threaded_request(GAME_PATH, "PackedScene", false)
	print("Loading game scene at ", GAME_PATH)

func _process(_delta):
	if stage == LoadingStage.LOADING:
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(GAME_PATH, progress)
		print("Progress: ",int(progress[0]*100),"%")
		
		if progress[0] == 1:
			print ("ResourceLoader completed job successfully")
			spawn_main_scene()
			stage = LoadingStage.SPAWNING

func spawn_main_scene() -> void:	
	print ("Initializing game scene")
	var scene = ResourceLoader.load_threaded_get(GAME_PATH)
	var main_scene : Node = scene.instantiate()
	get_tree().root.add_child(main_scene)
	queue_free()
