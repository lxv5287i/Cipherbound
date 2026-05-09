extends Camera2D

@export var target_path: NodePath
@export var follow_speed := 4.0

var target: Node2D = null

func _ready():
	enabled = true
	position_smoothing_enabled = true
	position_smoothing_speed = 4.0

	if target_path != NodePath(""):
		target = get_node_or_null(target_path)

	if target == null:
		print(name, " target not found: ", target_path)

func _process(delta):
	if target == null:
		return

	var target_position := target.global_position.round()
	global_position = global_position.lerp(target_position, follow_speed * delta).round()
