extends CanvasLayer

@export_multiline var hint_text := ""

@onready var panel: Panel = $Panel
@onready var hint_label: Label = $Panel/Label

var is_open := false

func _ready():
	add_to_group("analyst_interactable")

	panel.visible = false
	hint_label.visible = true
	hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_label.text = hint_text

func open_popup():
	is_open = true
	panel.visible = true

func close_popup():
	is_open = false
	panel.visible = false
