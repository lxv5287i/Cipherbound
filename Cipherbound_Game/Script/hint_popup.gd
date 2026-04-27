extends CanvasLayer

@onready var label: Label = $Panel/Label

func _ready():
	visible = false

func show_hint(text: String):
	label.text = text
	visible = true

func hide_hint():
	visible = false
