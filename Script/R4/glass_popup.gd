extends CanvasLayer

@export_multiline var popup_text := ""

@onready var panel: Panel = $Panel
@onready var text_label: Label = $Panel/Text

var is_open := false


func _ready():
	add_to_group("info_popup")

	panel.visible = false

	text_label.visible = true
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.text = popup_text


func open_popup():
	is_open = true
	panel.visible = true
	text_label.text = popup_text


func close_popup():
	is_open = false
	panel.visible = false
