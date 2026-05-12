extends CanvasLayer

@onready var panel = $PanelContainer

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	show()
	# start below screen, slide up to center
	var screen_height = get_viewport().get_visible_rect().size.y
	panel.position.y = screen_height  # start off screen bottom
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)  # gives a nice bouncy feel
	tween.tween_property(panel, "position:y", 0, 0.8)  # slide to y=0 (center if anchored)

func close():
	var screen_height = get_viewport().get_visible_rect().size.y
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel, "position:y", screen_height, 0.8)
	await tween.finished
	hide()


func _on_continue_pressed() -> void:
	close()
	await get_tree().create_timer(0.3).timeout  # wait for close animation
	get_tree().get_first_node_in_group("main_menu").open_team_name()


func _on_cancel_pressed() -> void:
	close()


func _on_enter_tutorial_pressed() -> void:
	close()
	await get_tree().create_timer(0.3).timeout
	LoadingScreen.load_scene("res://Scenes/tutorial_level.tscn")
