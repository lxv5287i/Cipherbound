extends Area2D

@export var hint_text := "Hint: Read the condition carefully."

@onready var prompt_label: Label = $Label
@onready var hint_popup: CanvasLayer = $"../HintPopup"
@onready var sprite: Sprite2D = $Sprite2D 

var popup_open := false

func _ready():
	prompt_label.text = "[Space]"
	prompt_label.visible = false
	hint_popup.visible = false

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
	hint_popup.show_hint(hint_text)

func close_popup():
	popup_open = false
	hint_popup.hide_hint()
