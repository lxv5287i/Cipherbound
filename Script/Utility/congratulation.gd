extends CanvasLayer

@onready var panel = $PanelContainer

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
	tween.tween_property(panel, "position:y", 0, 0.6)

func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	GameLock.movement_locked = false
	GameProgress.full_reset()
	get_tree().change_scene_to_file("res://Assets/MAIN UI/mainMenu.tscn")
