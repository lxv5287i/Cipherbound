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

	if sprite.sprite_frames.has_animation(default_animation):
		sprite.play(default_animation)
	else:
		print("MISSING DEFAULT ANIMATION: ", default_animation)

func show_prompt():
	prompt_label.visible = true
	prompt_label.text = "[WELCOME]"


func hide_prompt():
	prompt_label.visible = false
	close_popup()
	sprite.play(default_animation)


func interact(player: Node2D = null):
	var real_player := get_nearest_player()

	if real_player == null:
		print("NO REAL PLAYER FOUND")
		return

	face_player(real_player)

	popup_open = true
	popup_canvas.visible = true
	rich_text_label.text = popup_text

	var level = get_tree().get_first_node_in_group("tutorial_level")
	if level and level.has_method("unlock_analyst"):
		level.unlock_analyst()


func face_player(player: Node2D):
	var direction: Vector2 = player.global_position - global_position

	print("ROBOT POS: ", global_position)
	print("REAL PLAYER POS: ", player.global_position)
	print("DIRECTION: ", direction)

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			sprite.play("right")
		else:
			sprite.play("left")
	else:
		if direction.y > 0:
			sprite.play("down")
		else:
			sprite.play("up")

func close_popup():
	popup_open = false
	popup_canvas.visible = false


func get_nearest_player() -> Node2D:
	var players: Array[Node] = []

	players.append_array(get_tree().get_nodes_in_group("analyst_player"))
	players.append_array(get_tree().get_nodes_in_group("coder_player"))

	var nearest_player: Node2D = null
	var nearest_distance := INF

	for p in players:
		if p == self:
			continue

		if not p is Node2D:
			continue

		var distance := global_position.distance_to(p.global_position)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest_player = p

	return nearest_player
