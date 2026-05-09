extends Camera2D

@export var min_zoom := 1.2
@export var max_zoom := 1.5
@export var near_distance := 48.0
@export var far_distance := 180.0
@export var zoom_speed := 2.5
@export var move_speed := 3.5

var analyst: Node2D
var coder: Node2D

func set_players(analyst_player: Node2D, coder_player: Node2D):
	analyst = analyst_player
	coder = coder_player

func _process(delta):
	if analyst == null or coder == null:
		return

	var midpoint := ((analyst.global_position + coder.global_position) / 2.0).round()
	global_position = global_position.lerp(midpoint, move_speed * delta).round()

	var distance := analyst.global_position.distance_to(coder.global_position)

	var t := inverse_lerp(near_distance, far_distance, distance)
	t = clamp(t, 0.0, 1.0)

	var target_zoom_value: float = lerp(max_zoom, min_zoom, t)
	var target_zoom := Vector2(target_zoom_value, target_zoom_value)

	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
