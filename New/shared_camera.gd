extends Camera2D

@export var player_1: Node2D
@export var player_2: Node2D

func _process(_delta):
	if player_1 == null or player_2 == null:
		return

	global_position = (
		player_1.global_position +
		player_2.global_position
	) / 2.0
