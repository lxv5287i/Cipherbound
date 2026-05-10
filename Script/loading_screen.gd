extends CanvasLayer

var target_scene := ""
var is_loading := false

@onready var anim = $AnimationPlayer
@onready var bg = $TextureRect
@onready var label = $Label

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func load_scene(path: String):
	target_scene = path
	is_loading = true
	show()
	bg.visible = true
	bg.modulate.a = 1
	anim.play("fade_in")
	ResourceLoader.load_threaded_request(path)

func _process(_delta):
	if not is_loading:
		return

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(target_scene, progress)

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		is_loading = false
		_finish_loading()

func _finish_loading():
	var scene = ResourceLoader.load_threaded_get(target_scene)
	get_tree().change_scene_to_packed(scene)
	anim.play("fade_out")
	await anim.animation_finished
	hide()
