extends CanvasLayer

@onready var team_input: LineEdit = $PanelContainer/LineEdit
@onready var panel = $PanelContainer  # adjust to your actual panel path

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	show()
	var screen_height = get_viewport().get_visible_rect().size.y
	panel.position.y = screen_height
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel, "position:y", 0, 0.8)

func close():
	var screen_height = get_viewport().get_visible_rect().size.y
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel, "position:y", screen_height, 0.8)
	await tween.finished
	hide()

func _on_enter_game_pressed() -> void:
	var team_name = team_input.text.strip_edges()
	if team_name == "":
		team_name = "Team 1"
	GameProgress.team_name = team_name
	
	# Debug unlock
	if team_name == "w@np1pdevs":
		GameProgress.room3_unlocked = true
		GameProgress.room4_unlocked = true
		GameProgress.room5_unlocked = true
		GameProgress.analyst_done = true
		GameProgress.coder_done = true
		GameProgress.room4_analyst_opened_count = 999
		GameProgress.room4_coder_done = true
		GameProgress.room4_done_signal_sent = true 
		GameProgress.room5_analyst_solved = true
		GameProgress.room5_coder_solved = true
		GameProgress.room5_done_signal_sent = true

	close()
	await get_tree().create_timer(0.3).timeout
	LoadingScreen.load_scene("res://Scenes/Utility/SplitScreenMain.tscn")

func _on_cancel_pressed() -> void:
	close()
	await get_tree().create_timer(0.3).timeout
	get_tree().get_first_node_in_group("main_menu").open_char_info()
