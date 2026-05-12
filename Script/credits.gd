extends CanvasLayer
@onready var panel = $PanelContainer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	show()
	var screen_height = get_viewport().get_visible_rect().size.y
	panel.position.y = screen_height
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel, "position:y", 0, 0.8)

func close():
	var screen_height = get_viewport().get_visible_rect().size.y
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel, "position:y", screen_height, 0.8)
	await tween.finished
	hide()


func _on_cancel_pressed() -> void:
	close()
