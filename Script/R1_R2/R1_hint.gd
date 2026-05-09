extends CanvasLayer

@onready var panel: Panel = get_node_or_null("Panel")

var is_open := false

func _ready():
	visible = true

	if panel == null:
		push_error("R1_hint error: Panel node not found. Add a Panel child named exactly 'Panel'.")
		return

	panel.visible = false

func open_popup():
	is_open = true

	if panel:
		panel.visible = true

func close_popup():
	is_open = false

	if panel:
		panel.visible = false
