extends Area2D

@onready var prompt_label: Label = $Label
@onready var popup: CanvasLayer = $"../CoderPuzzlePopup"
@onready var sprite: Sprite2D = $Sprite2D

var popup_open := false

func _ready():
	prompt_label.text = "Press [E]"
	prompt_label.visible = false

	popup.connect("puzzle_solved", _on_solved)

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

func _on_solved():
	sprite.texture = preload("res://Interactables/poweron.png")
	close_popup()
