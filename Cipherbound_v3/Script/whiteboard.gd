extends Area2D

@onready var prompt_label: Label = $Label
@onready var popup: CanvasLayer = $"../AnalystPuzzlePopup"

var popup_open := false

func _ready():
	prompt_label.text = "[Space]"
	prompt_label.visible = false

func show_prompt():
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false

func interact():
	if popup_open:
		close_popup()
	else:
		open_popup()

func open_popup():
	popup_open = true
	popup.open_popup()

func close_popup():
	popup_open = false
	popup.close_popup()
