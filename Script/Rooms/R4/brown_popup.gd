extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var text_label: RichTextLabel = $Panel/Text

var is_open := false
var x := 0
var i := 5

func _ready():
	add_to_group("info_popup")

	panel.visible = false

	text_label.visible = true
	text_label.bbcode_enabled = true
	text_label.scroll_active = true
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func open_popup():
	is_open = true

	panel.visible = true
	text_label.visible = true


func close_popup():
	is_open = false
	panel.visible = false
