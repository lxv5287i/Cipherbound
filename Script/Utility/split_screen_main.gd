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
@onready var timer_label: Label = $HUD/TimerLabel
@onready var congratulation = $Congratulation

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("split_screen_main")
	get_tree().paused = false
	GameLock.movement_locked = false
	use_split_screen()
	GameTimer.start()

func use_split_screen():
	split_container.visible = true
	shared_view_container.visible = false
	coder_camera.make_current()
	analyst_camera.make_current()

func use_shared_screen():
	split_container.visible = false
	shared_view_container.visible = true
	shared_camera.make_current()

func _process(_delta):
	if timer_label:
		timer_label.text = GameTimer.get_formatted()
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause():
	if pause_menu.visible:
		pause_menu.close() 
	else:
		GameTimer.pause_timer()
		pause_menu.open()

func _on_pause_pressed() -> void:
	_toggle_pause()

func go_to_lobby():
	print("Changing to lobby")
	change_shared_room("res://Scenes/Rooms/Lobby.tscn", 1.2)

func go_to_room3():
	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress:
		progress.reset_room_progress()
	change_shared_room("res://Scenes/Rooms/room3.tscn")

func go_to_room4():
	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress:
		progress.reset_room_progress()
	change_shared_room("res://Scenes/Rooms/room4.tscn")

func go_to_room5():
	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress and progress.has_method("reset_room_progress"):
		progress.reset_room_progress()
	change_shared_room("res://Scenes/Rooms/room5.tscn")

func game_complete():
	LoadingScreen.active = false
	LoadingScreen.hide()
	GameProgress.lock_all_rooms()
	GameTimer.stop()
	GameTimer.save_score()
	GameLock.movement_locked = true
	congratulation.open()

func change_shared_room(room_path: String, min_loading_time: float = 0.3):
	if not LoadingScreen.active:
		LoadingScreen.show_overlay()

	await get_tree().process_frame

	ResourceLoader.load_threaded_request(room_path)
	while true:
		var status = ResourceLoader.load_threaded_get_status(room_path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Failed to load: " + room_path)
			LoadingScreen.hide_overlay()
			return
		await get_tree().process_frame

	use_shared_screen()
	move_players_to_shared_world()

	for child in shared_world.get_children():
		if child != shared_camera and child != coder_player and child != analyst_player:
			child.queue_free()

	await get_tree().process_frame

	var new_room = ResourceLoader.load_threaded_get(room_path).instantiate()
	shared_world.add_child(new_room)
	shared_world.move_child(new_room, 0)

	var coder_spawn: Marker2D = new_room.find_child("CoderSpawn", true, false)
	var analyst_spawn: Marker2D = new_room.find_child("AnalystSpawn", true, false)

	if coder_spawn == null or analyst_spawn == null:
		push_error("Spawn points not found in: " + room_path)
		LoadingScreen.hide_overlay()
		return

	place_players(coder_spawn.global_position, analyst_spawn.global_position)
	await get_tree().create_timer(min_loading_time).timeout
	LoadingScreen.hide_overlay()

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
	shared_camera.make_current()
