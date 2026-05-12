extends Camera2D

@export var target: Node2D

func _process(_delta):
	if target == null:
		return

	global_position = target.global_position.round()
	zoom = Vector2.ONE
