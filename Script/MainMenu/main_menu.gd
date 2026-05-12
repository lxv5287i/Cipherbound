extends Node2D


@onready var char_info = $charInfo     
@onready var team_name_popup = $teamName 
@onready var leeaderboard = $Leaderboard 
@onready var credits = $Credits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("main_menu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	char_info.open()

func open_team_name():
	team_name_popup.open()


func _toggle_pause():
	if char_info.visible:
		char_info.close()
	else:
		char_info.open()

func _on_credits_pressed() -> void:
	credits.open()


func _on_leaderboard_pressed() -> void:
	leeaderboard.open()


func _on_exit_pressed() -> void:
	get_tree().quit()

func open_char_info():
	char_info.open()
