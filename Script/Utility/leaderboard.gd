extends CanvasLayer

@onready var panel = $PanelContainer
@onready var entries_container: VBoxContainer = $PanelContainer/ScrollContainer/EntriesContainer
@onready var reset_button: Button = $PanelContainer/ResetButton

@export var leaderboard_music: AudioStream

var _main_menu_music: AudioStream = null

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	var main_menu = get_tree().get_first_node_in_group("main_menu")
	if main_menu:
		var room_controller = main_menu.get_node_or_null("RoomMusicController")
		if room_controller and room_controller.room_music:
			_main_menu_music = room_controller.room_music

	show()
	_populate()

	if leaderboard_music:
		MusicManager.play_music(leaderboard_music)

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

	if _main_menu_music:
		MusicManager.play_music(_main_menu_music)

func _on_cancel_pressed() -> void:
	close()

func _populate():
	for child in entries_container.get_children():
		child.queue_free()

	var scores = GameTimer.load_scores()
	for i in scores.size():
		var s = scores[i]
		entries_container.add_child(_make_row(str(i + 1), s["team"], _format_elapsed(s["time"])))

func _make_row(rank: String, team: String, time: String) -> HBoxContainer:
	var row = HBoxContainer.new()
	row.custom_minimum_size.y = 25
	row.add_theme_constant_override("separation", 0)

	var font = load("res://Assets/Fonts/PixelOperator-Bold.ttf")
	var font_size = 16

	var rank_lbl = Label.new()
	rank_lbl.text = rank
	rank_lbl.custom_minimum_size.x = 60
	rank_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	rank_lbl.add_theme_font_override("font", font)
	rank_lbl.add_theme_font_size_override("font_size", font_size)

	var team_lbl = Label.new()
	team_lbl.text = team
	team_lbl.custom_minimum_size.x = 215
	team_lbl.size_flags_horizontal = Control.SIZE_FILL
	team_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	team_lbl.add_theme_font_override("font", font)
	team_lbl.add_theme_font_size_override("font_size", font_size)

	var time_lbl = Label.new()
	time_lbl.text = time
	time_lbl.custom_minimum_size.x = 25
	time_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	time_lbl.add_theme_font_override("font", font)
	time_lbl.add_theme_font_size_override("font_size", font_size)

	row.add_child(rank_lbl)
	row.add_child(team_lbl)
	row.add_child(time_lbl)
	return row

func _format_elapsed(elapsed_seconds: float) -> String:
	var total = int(clamp(elapsed_seconds, 0.0, 1800.0))
	return "%02d:%02d" % [total / 60, total % 60]

func _on_reset_button_pressed() -> void:
	GameTimer.reset_leaderboard()
	_populate()
