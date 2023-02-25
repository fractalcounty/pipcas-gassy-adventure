extends Control

@export_category("Boot Settings")
@export_dir var game_path : String
@export var threaded_loading : bool
@export var label : Label

var duration : float
var expected_duration : float = 0
var stage := LoadingStage.LOADING
enum LoadingStage {LOADING, SPAWNING}

func _ready():
	var file = FileAccess.open("user://boot.time", FileAccess.READ)
	if file:
		expected_duration = file.get_float()
	
	ResourceLoader.load_threaded_request(game_path, "PackedScene", threaded_loading)
	print("Loading game scene at ", game_path)

func _process(_delta):
	duration = Time.get_ticks_msec()
	var clamped_duration = duration / (expected_duration if expected_duration != 0 else 5.0)
	var new_dur = str(int(clamp(remap((clamped_duration * 100),50 , 100, 1, 100), 1, 100)))
	
	if stage == LoadingStage.LOADING:
		#print (new_dur + "%")
		label.set_text(str(new_dur) + "%")
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(game_path, progress)
		
		if progress[0] == 1:
			print ("ResourceLoader completed job successfully")
			spawn_main_scene()
			stage = LoadingStage.SPAWNING

func spawn_main_scene() -> void:	
	print ("Initializing game scene")
	var scene = ResourceLoader.load_threaded_get(game_path)
	var game_scene : Node = scene.instantiate()
	get_tree().root.add_child(game_scene)
	
	if !game_scene:
		push_error("Main scene failed to load.")
	
	if expected_duration == 0:
		expected_duration = duration
	else:
		expected_duration = (duration + expected_duration) /2

	var file = FileAccess.open("user://boot.time", FileAccess.WRITE)
	if file:
		file.store_float(expected_duration)
		file.flush()
	
	queue_free()
