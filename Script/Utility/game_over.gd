extends CanvasLayer

@onready var panel = $Control

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	show()

	get_tree().paused = true
	GameLock.movement_locked = true

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	$Control.scale = Vector2(0.8, 0.8)
	tween.tween_property($Control, "scale", Vector2(1, 1), 0.8)

func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	GameLock.movement_locked = false
	GameProgress.full_reset()

	MusicManager.volume_db = -10

	get_tree().change_scene_to_file(
		"res://Assets/Main Menu/mainMenu.tscn"
	)
