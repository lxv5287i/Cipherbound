extends CanvasLayer

var dot_count := 0
var dot_timer := 0.0
var dot_interval := 0.4
var active := false
var target_scene := ""

var tips: Array[String] = [
	"Tip: The Analyst reads the clues. The Coder writes the solution. Work together!",
	"Tip: Both players must stand on the exit door at the same time to proceed.",
	"Tip: The Analyst unlocks information that the Coder needs to solve the puzzle.",
	"Tip: Stuck? Re-read the problem carefully — the answer is always in the details.",
	"Tip: Make sure to check objects around you. Who knows, they might teach you a thing or two.",
]

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var bg: TextureRect = $TextureRect
@onready var label: RichTextLabel = $Label

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	var placeholder: Texture2D = load("res://Assets/World/Utility/loading_screen.png")
	if placeholder:
		bg.texture = placeholder
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _process(delta):
	if not active:
		return
	if target_scene == "":
		return
	dot_timer += delta
	if dot_timer >= dot_interval:
		dot_timer = 0.0
		dot_count += 1
		if dot_count > 3:
			dot_count = 1
		# update only the dots part, keep the tip text
		var current = label.text
		var base = current.rstrip(".")
		label.text = base + ".".repeat(dot_count)

func show_overlay():
	if active:
		return
	active = true
	target_scene = ""
	dot_count = 1
	dot_timer = 0.0
	# pick a random tip
	var tip = tips[randi() % tips.size()]
	label.text = tip + "."
	show()
	anim.play("fade_in")

func hide_overlay():
	if not active:
		return
	active = false
	target_scene = ""
	anim.play("fade_out")
	await anim.animation_finished
	hide()

func load_scene(path: String):
	target_scene = path
	show_overlay()
	ResourceLoader.load_threaded_request(path)
	while true:
		var status = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("LoadingScreen: failed to load " + path)
			hide_overlay()
			return
		await get_tree().process_frame
	var scene = ResourceLoader.load_threaded_get(path)
	get_tree().change_scene_to_packed(scene)
	await hide_overlay()
