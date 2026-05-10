extends CanvasLayer

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	show()
	get_tree().paused = true
	GameLock.movement_locked = true

func close():
	hide()
	get_tree().paused = false
	GameLock.movement_locked = false

func _on_resume_pressed():
	close()

func _on_quit_to_menu_pressed():
	get_tree().paused = false
	GameLock.movement_locked = false
	get_tree().change_scene_to_file("res://Scenes/MAIN UI/mainMenu.tscn")
