extends Control

@onready var left_view: SubViewport = $HBoxContainer/LeftSide/AnalystView
@onready var right_view: SubViewport = $HBoxContainer/RightSide/CoderView

@onready var left_cam: Camera2D = $HBoxContainer/LeftSide/AnalystView/AnalystCam
@onready var right_cam: Camera2D = $HBoxContainer/RightSide/CoderView/CoderCam

@onready var left_player: Node2D = $HBoxContainer/LeftSide/AnalystView/Room2/CoderPlayer
@onready var right_player: Node2D = $HBoxContainer/RightSide/CoderView/Room1/AnalystPlayer

func _ready():
	left_cam.enabled = true
	right_cam.enabled = true

	left_cam.make_current()
	right_cam.make_current()

func _process(_delta):
	if left_player:
		left_cam.global_position = left_player.global_position

	if right_player:
		right_cam.global_position = right_player.global_position

func go_to_room3():
	var room3_scene := preload("res://Scenes/room3.tscn")
	var coder_scene := preload("res://Character/Coder/coder_player.tscn")
	var analyst_scene := preload("res://Character/Analyst/analyst_player.tscn")

	clear_view(left_view)
	clear_view(right_view)

	var room3_left = room3_scene.instantiate()
	var room3_right = room3_scene.instantiate()

	room3_left.name = "Room3_Left"
	room3_right.name = "Room3_Right"

	left_view.add_child(room3_left)
	right_view.add_child(room3_right)

	var coder_spawn: Marker2D = room3_left.get_node("CoderSpawn")
	var analyst_spawn: Marker2D = room3_right.get_node("AnalystSpawn")

	var coder = coder_scene.instantiate()
	var analyst = analyst_scene.instantiate()

	coder.name = "CoderPlayer"
	analyst.name = "AnalystPlayer"

	room3_left.add_child(coder)
	room3_right.add_child(analyst)

	coder.global_position = coder_spawn.global_position
	analyst.global_position = analyst_spawn.global_position

	left_player = coder
	right_player = analyst

	left_cam.make_current()
	right_cam.make_current()

func clear_view(view: SubViewport):
	for child in view.get_children():
		if child is Camera2D:
			continue
		child.queue_free()
