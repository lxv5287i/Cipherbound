extends CanvasLayer

@onready var panel = $PanelContainer
@onready var entries_container: VBoxContainer = $PanelContainer/ScrollContainer/EntriesContainer
@onready var reset_button: Button = $PanelContainer/ResetButton
@onready var music: AudioStreamPlayer = $LeaderboardMusic

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	music.volume_db = 0
func open():
	show()
	_populate()
	MusicManager.volume_db = -30
	music.volume_db = 0
	music.play()

	var fade_in = create_tween()
	fade_in.tween_property(music, "volume_db", -15, 4.0) #adjust the music f(ade in)

	var screen_height = get_viewport().get_visible_rect().size.y
	panel.position.y = screen_height

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel, "position:y", 0, 0.8)

func close():
	MusicManager.volume_db = -15 #adjust the bg music

	var fade_out = create_tween()
	fade_out.tween_property(music, "volume_db", -40, 2.0)

	var screen_height = get_viewport().get_visible_rect().size.y

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel, "position:y", screen_height, 0.8)

	await tween.finished

	music.stop()
	hide()


func _on_cancel_pressed() -> void:
	close()


func _populate():
	for child in entries_container.get_children():
		child.queue_free()

	var scores = GameTimer.load_scores()

	if scores.is_empty():
		var empty = Label.new()
		empty.text = ""
		entries_container.add_child(empty)
		return

	for i in scores.size():
		var s = scores[i]
		var time_str = _format_time(s["time"])
		var row = _make_row(s["team"], time_str)
		entries_container.add_child(row)


func _make_row(team: String, time: String) -> HBoxContainer:
	var row = HBoxContainer.new()
	row.custom_minimum_size.y = 25
	row.add_theme_constant_override("separation", 0)

	var spacer = Control.new()
	spacer.custom_minimum_size.x = 80

	var team_lbl = Label.new()
	team_lbl.text = team
	team_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	team_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	var time_lbl = Label.new()
	time_lbl.text = time
	time_lbl.custom_minimum_size.x = 120
	time_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	var font = load("res://Assets/Fonts/PixelOperator-Bold.ttf")
	var font_size = 16

	team_lbl.add_theme_font_override("font", font)
	team_lbl.add_theme_font_size_override("font_size", font_size)

	time_lbl.add_theme_font_override("font", font)
	time_lbl.add_theme_font_size_override("font_size", font_size)

	row.add_child(team_lbl)
	row.add_child(time_lbl)

	return row


func _format_time(seconds: float) -> String:
	var total = int(seconds)
	var h = total / 3600
	var m = (total % 3600) / 60
	var s = total % 60

	return "%02d:%02d:%02d" % [h, m, s]


func _on_reset_button_pressed() -> void:
	GameTimer.reset_leaderboard()
	_populate()
