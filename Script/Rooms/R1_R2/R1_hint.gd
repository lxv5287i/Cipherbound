extends CanvasLayer

@onready var panel: Panel = get_node_or_null("Panel")
@onready var explanation_label: RichTextLabel = get_node_or_null("Panel/ExplanationLabel")

var is_open := false


func _ready():
	visible = true

	if panel == null:
		push_error("Panel node not found.")
		return

	if explanation_label == null:
		push_error("ExplanationLabel node not found.")
		return

	panel.visible = false

	explanation_label.visible = true
	explanation_label.bbcode_enabled = true
	explanation_label.scroll_active = true
	explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func open_popup():
	if panel == null:
		return

	is_open = true

	visible = true
	panel.visible = true

	if explanation_label:
		explanation_label.visible = true


func close_popup():
	if panel == null:
		return

	is_open = false
	panel.visible = false
