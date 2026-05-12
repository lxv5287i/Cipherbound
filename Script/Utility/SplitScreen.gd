extends Control

@onready var split_container: Control = $HBoxContainer
@onready var shared_view: Node2D = $SharedView

@onready var analyst_cam: Camera2D = $HBoxContainer/RightSide/AnalystView/AnalystCam
@onready var coder_cam: Camera2D = $HBoxContainer/LeftSide/CoderView/CoderCam
@onready var shared_cam: Camera2D = $SharedView/SharedCam

@onready var analyst_player: Node2D = $HBoxContainer/RightSide/AnalystView/AnalystPlayer
@onready var coder_player: Node2D = $HBoxContainer/LeftSide/CoderView/CoderPlayer

func _ready():
	shared_cam.set_players(analyst_player, coder_player)
	use_split_screen()

func use_split_screen():
	split_container.visible = true
	shared_view.visible = false

	analyst_cam.enabled = true
	coder_cam.enabled = true
	shared_cam.enabled = false

func use_shared_screen():
	split_container.visible = false
	shared_view.visible = true

	analyst_cam.enabled = false
	coder_cam.enabled = false
	shared_cam.enabled = true
@onready var current_shared_room: Node2D = $SharedView/CurrentSharedRoom

func load_shared_room(room_path: String):
	use_shared_screen()

	for child in current_shared_room.get_children():
		child.queue_free()

	var room_scene: PackedScene = load(room_path)

	if room_scene == null:
		print("ERROR: Cannot load room: ", room_path)
	return

	var room: Node = room_scene.instantiate()
	current_shared_room.add_child(room)

	await get_tree().process_frame

	var analyst_spawn = room.get_node_or_null("AnalystSpawn")
	var coder_spawn = room.get_node_or_null("CoderSpawn")

	if analyst_spawn:
		analyst_player.global_position = analyst_spawn.global_position
	else:
		print("ERROR: AnalystSpawn missing in ", room_path)

	if coder_spawn:
		coder_player.global_position = coder_spawn.global_position
	else:
		print("ERROR: CoderSpawn missing in ", room_path)
