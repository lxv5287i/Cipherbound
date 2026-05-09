extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var text_label: Label = $Panel/Label

var is_open := false

func _ready():
	add_to_group("info_popup")
	panel.visible = false
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func open_popup(text: String):
	is_open = true
	panel.visible = true
	text_label.text = text

func close_popup():
	is_open = false
	panel.visible = false
