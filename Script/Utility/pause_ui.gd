extends CanvasLayer

@onready var panel = $PanelContainer

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	show()
	var screen_height = get_viewport().get_visible_rect().size.y
	var screen_width = get_viewport().get_visible_rect().size.x
	
	# force center position first
	panel.global_position = Vector2(
		(screen_width - panel.size.x) / 2,
		screen_height  # start below screen
	)
	
	get_tree().paused = true
	GameLock.movement_locked = true
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	# slide up to vertical center
	var target_y = (screen_height - panel.size.y) / 2
	tween.tween_property(panel, "global_position:y", target_y, 0.8)

func close():
	var screen_height = get_viewport().get_visible_rect().size.y
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel, "global_position:y", screen_height, 0.3)
	await tween.finished
	hide()
	get_tree().paused = false
	GameLock.movement_locked = false

func _on_resume_pressed() -> void:
	close()

func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	GameLock.movement_locked = false
	get_tree().change_scene_to_file("res://Assets/MAIN UI/mainMenu.tscn")
