extends CanvasLayer

@onready var team_label: Label = $PanelContainer/TeamLabel

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	if team_label:
		team_label.text = GameProgress.team_name
	show()
	get_tree().paused = true
	GameLock.movement_locked = true

func close():
	hide()
	get_tree().paused = false
	GameLock.movement_locked = false
	GameTimer.resume_timer()    # ← move it here

func _on_resume_pressed():
	close()

func _on_quit_to_menu_pressed():
	get_tree().paused = false
	GameLock.movement_locked = false
	GameTimer.stop()
	get_tree().change_scene_to_file("res://Scenes/MAIN UI/mainMenu.tscn")
