extends CanvasLayer

@onready var panel = $PanelContainer
@onready var entries_container: VBoxContainer = $PanelContainer/ScrollContainer/EntriesContainer
@onready var reset_button: Button = $PanelContainer/ResetButton

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	show()
	_populate()
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

func _on_cancel_pressed() -> void:
	close()

func _populate():
	for child in entries_container.get_children():
		child.queue_free()

	var scores = GameTimer.load_scores()

	if scores.is_empty():
		var empty = Label.new()
		empty.text = "No records yet."
		entries_container.add_child(empty)
		return

	# Header
	var header = _make_row("RANK", "TEAM", "TIME", true)
	entries_container.add_child(header)

	for i in scores.size():
		var s = scores[i]
		var time_str = _format_time(s["time"])
		var row = _make_row(str(i + 1), s["team"], time_str, false)
		entries_container.add_child(row)

func _make_row(rank: String, team: String, time: String, is_header: bool) -> HBoxContainer:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)

	for text in [rank, team, time]:
		var lbl = Label.new()
		lbl.text = text
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if is_header:
			lbl.add_theme_color_override("font_color", Color.YELLOW)
		row.add_child(lbl)

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
