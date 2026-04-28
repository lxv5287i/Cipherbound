extends Area2D

@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $AnimationPlayer

var door_open := false
var player_near := false
var nearby_player: Node2D = null

@export var close_distance := 48.0

func _ready():
	label.visible = false
	open_door()

func _process(_delta):
	if door_open and nearby_player != null:
		var distance := global_position.distance_to(nearby_player.global_position)

		if distance > close_distance:
			nearby_player = null
			player_near = false
			label.visible = false
			close_door()

func open_door():
	if door_open:
		return

	door_open = true
	label.text = "Open"
	anim.play("open")

func close_door():
	if not door_open:
		return

	door_open = false
	label.text = "Locked"
	anim.play("close")

func _on_body_entered(body):
	if body.name != "AnalystPlayer" and body.name != "CoderPlayer":
		return

	nearby_player = body
	player_near = true
	label.visible = true
	label.text = "Open"

func _on_body_exited(body):
	if body != nearby_player:
		return

	nearby_player = null
	player_near = false
	label.visible = false
	close_door()
