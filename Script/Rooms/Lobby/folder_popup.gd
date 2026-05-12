extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var text_label: RichTextLabel = $Panel/Label

var is_open := false
var current_source: Node = null


func _ready():
	add_to_group("info_popup")

	panel.visible = false

	text_label.visible = true
	text_label.bbcode_enabled = true
	text_label.scroll_active = true
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func open_popup(text: String, popup_source: Node):
	current_source = popup_source
	is_open = true

	panel.visible = true
	text_label.visible = true
	text_label.text = text


func close_popup_for(popup_source: Node):
	if current_source == popup_source:
		close_popup()


func close_popup():
	is_open = false
	current_source = null
	panel.visible = false
