extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name != "CoderPlayer" and body.name != "AnalystPlayer":
		return

	var main = get_tree().get_first_node_in_group("split_screen_main")
	if main:
		main.call_deferred("go_to_room4")
