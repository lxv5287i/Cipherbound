extends Area2D

@export_multiline var popup_text: String = "Put robot text here."
@export var default_animation: String = "down"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var prompt_label: Label = $Label
@onready var popup_canvas: CanvasLayer = $CanvasLayer
@onready var rich_text_label: RichTextLabel = $CanvasLayer/Panel/RichTextLabel

var popup_open := false


func _ready():
	add_to_group("analyst_interactable")
	add_to_group("coder_interactable")

	prompt_label.visible = false
	popup_canvas.visible = false

	rich_text_label.bbcode_enabled = true
	rich_text_label.text = popup_text

	sprite.play(default_animation)


func show_prompt():
	prompt_label.visible = true
	prompt_label.text = "SPACE / E"


func hide_prompt():
	prompt_label.visible = false
	close_popup()

	sprite.play(default_animation)


func interact(player: Node2D = null):

	if player == null:
		player = get_nearest_player()

	if player == null:
		print("NO PLAYER FOUND")
		return

	face_player(player)

	popup_open = true
	popup_canvas.visible = true

	rich_text_label.text = popup_text


func close_popup():
	popup_open = false
	popup_canvas.visible = false


func get_nearest_player() -> Node2D:

	var analyst = get_tree().get_first_node_in_group("analyst_player")
	var coder = get_tree().get_first_node_in_group("coder_player")

	var nearest_player: Node2D = null
	var nearest_distance := 999999.0

	if analyst != null:

		var analyst_distance = global_position.distance_to(analyst.global_position)

		if analyst_distance < nearest_distance:
			nearest_distance = analyst_distance
			nearest_player = analyst

	if coder != null:

		var coder_distance = global_position.distance_to(coder.global_position)

		if coder_distance < nearest_distance:
			nearest_distance = coder_distance
			nearest_player = coder

	return nearest_player


func face_player(player: Node2D):

	var direction: Vector2 = player.global_position - sprite.global_position

	print("PLAYER: ", player.name)
	print("DIRECTION: ", direction)

	# LEFT / RIGHT
	if abs(direction.x) > abs(direction.y):

		# PLAYER IS RIGHT
		if direction.x > 0:
			sprite.play("right")

		# PLAYER IS LEFT
		else:
			sprite.play("left")

	# UP / DOWN
	else:

		# PLAYER IS BELOW
		if direction.y > 0:
			sprite.play("down")

		# PLAYER IS ABOVE
		else:
			sprite.play("up")
