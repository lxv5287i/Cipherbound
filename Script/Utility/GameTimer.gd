extends Node

var elapsed_time: float = 0.0
var running: bool = false
var game_over_triggered := false

func _process(delta):
	if game_over_triggered:
		return

	if running:
		elapsed_time += delta

	if elapsed_time >= 1800:
		game_over_triggered = true
		show_game_over()

func start():
	elapsed_time = 0.0
	running = true
	game_over_triggered = false

func stop():
	running = false

func pause_timer():
	running = false

func resume_timer():
	running = true

func add_penalty(seconds: float):
	elapsed_time += seconds

func get_formatted() -> String:
	var total = int(elapsed_time)
	var h = total / 3600
	var m = (total % 3600) / 60
	var s = total % 60
	return "%02d:%02d:%02d" % [h, m, s]

func save_score():
	var team = GameProgress.team_name
	var time = elapsed_time

	var scores = _load_scores()
	scores.append({"team": team, "time": time})
	scores.sort_custom(func(a, b): return a["time"] < b["time"])

	var file = FileAccess.open("user://leaderboard.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(scores))
		file.close()

func _load_scores() -> Array:
	if not FileAccess.file_exists("user://leaderboard.json"):
		return []
	var file = FileAccess.open("user://leaderboard.json", FileAccess.READ)
	if not file:
		return []
	var text = file.get_as_text()
	file.close()
	var result = JSON.parse_string(text)
	if result is Array:
		return result
	return []

func load_scores() -> Array:
	return _load_scores()

func reset_leaderboard():
	if FileAccess.file_exists("user://leaderboard.json"):
		DirAccess.remove_absolute(
			OS.get_user_data_dir() + "/leaderboard.json"
		)
		print("Leaderboard reset.")

func show_game_over():
	running = false

	var game_over_scene = preload(
		"res://Scenes/Utility/game_over.tscn"
	)

	var game_over = game_over_scene.instantiate()

	get_tree().current_scene.add_child(game_over)

	game_over.open()
