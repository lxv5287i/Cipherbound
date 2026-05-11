extends Control

@onready var split_container = $SplitContainer
@onready var shared_view_container = $SharedViewContainer
@onready var shared_world = $SharedViewContainer/SharedViewport/SharedWorld

@onready var coder_camera = $SplitContainer/CoderViewContainer/CoderViewport/CoderWorld/CoderCamera
@onready var analyst_camera = $SplitContainer/AnalystViewContainer/AnalystViewport/AnalystWorld/AnalystCamera
@onready var shared_camera = $SharedViewContainer/SharedViewport/SharedWorld/SharedCamera

@onready var coder_player = $SplitContainer/CoderViewContainer/CoderViewport/CoderWorld/CoderPlayer
@onready var analyst_player = $SplitContainer/AnalystViewContainer/AnalystViewport/AnalystWorld/AnalystPlayer

@onready var pause_menu = $PauseMenu 

func _ready():
	add_to_group("split_screen_main")
	use_split_screen()


func use_split_screen():
	split_container.visible = true
	shared_view_container.visible = false
	coder_camera.enabled = true
	analyst_camera.enabled = true
	shared_camera.enabled = false


func use_shared_screen():
	split_container.visible = false
	shared_view_container.visible = true
	coder_camera.enabled = false
	analyst_camera.enabled = false
	shared_camera.enabled = true


func go_to_lobby():
	print("Changing to lobby")
	change_shared_room("res://Scenes/Lobby.tscn")


func go_to_room3():
	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress:
		progress.reset_room_progress()
	
	print("Changing to room 3")
	change_shared_room("res://Scenes/room3.tscn")


func go_to_room4():
	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress:
		progress.reset_room_progress()

	print("Changing to room 4")
	change_shared_room("res://Scenes/room4.tscn")


func go_to_room5():
	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress:
		if progress.has_method("reset_room_progress"):
			progress.reset_room_progress()

	print("Changing to room 5")

	change_shared_room("res://Scenes/room5.tscn")

func change_shared_room(room_path: String):
	use_shared_screen()
	move_players_to_shared_world()

	for child in shared_world.get_children():
		if child != shared_camera and child != coder_player and child != analyst_player:
			child.queue_free()

	var new_room = load(room_path).instantiate()
	shared_world.add_child(new_room)
	shared_world.move_child(new_room, 0)

	var coder_spawn: Marker2D = new_room.get_node("CoderSpawn")
	var analyst_spawn: Marker2D = new_room.get_node("AnalystSpawn")
	place_players(coder_spawn.global_position, analyst_spawn.global_position)


func move_players_to_shared_world():
	if coder_player.get_parent() != shared_world:
		if coder_player.get_parent():
			coder_player.get_parent().remove_child(coder_player)
		shared_world.add_child(coder_player)

	if analyst_player.get_parent() != shared_world:
		if analyst_player.get_parent():
			analyst_player.get_parent().remove_child(analyst_player)
		shared_world.add_child(analyst_player)


func place_players(coder_pos: Vector2, analyst_pos: Vector2):
	coder_player.global_position = coder_pos
	analyst_player.global_position = analyst_pos

	if "grid_position" in coder_player:
		coder_player.grid_position = coder_player.global_position

	if "grid_position" in analyst_player:
		analyst_player.grid_position = analyst_player.global_position

	if "is_moving" in coder_player:
		coder_player.is_moving = false

	if "is_moving" in analyst_player:
		analyst_player.is_moving = false

	shared_camera.player_1 = coder_player
	shared_camera.player_2 = analyst_player
	shared_camera.enabled = true
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):  # ESC key
		_toggle_pause()

func _toggle_pause():
	if pause_menu.visible:
		pause_menu.close()
	else:
		pause_menu.open()

func _on_pause_pressed() -> void:
	_toggle_pause()
