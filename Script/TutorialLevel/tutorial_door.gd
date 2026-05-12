extends Area2D

@export var main_menu_scene: String = "res://Scenes/MAIN UI/mainMenu.tscn"

@export var closed_texture: Texture2D
@export var closed_inrange_texture: Texture2D
@export var open_texture: Texture2D
@export var open_inrange_texture: Texture2D

@export var locked_text: String = "[LOCKED]"
@export var waiting_text: String = "[WAITING]"
@export var exit_text: String = "[EXIT]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var analyst_in_range: bool = false
var coder_in_range: bool = false
var transferring: bool = false


func _ready():
	label.visible = false

	if closed_texture:
		sprite.texture = closed_texture

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


func _process(_delta):
	update_door_state()


func _on_body_entered(body):
	if body.is_in_group("analyst_player") or body.name == "AnalystPlayer":
		analyst_in_range = true

	if body.is_in_group("coder_player") or body.name == "CoderPlayer":
		coder_in_range = true

	update_door_state()


func _on_body_exited(body):
	if body.is_in_group("analyst_player") or body.name == "AnalystPlayer":
		analyst_in_range = false

	if body.is_in_group("coder_player") or body.name == "CoderPlayer":
		coder_in_range = false

	update_door_state()


func update_door_state():
	if transferring:
		return

	var level = get_tree().get_first_node_in_group("tutorial_level")

	if level == null:
		label.visible = true
		label.text = locked_text
		set_texture(false, analyst_in_range or coder_in_range)
		return

	var unlocked: bool = bool(level.analyst_done) and bool(level.coder_done)
	var someone_in_range: bool = analyst_in_range or coder_in_range
	var both_in_range: bool = analyst_in_range and coder_in_range

	set_texture(unlocked, someone_in_range)

	if not someone_in_range:
		label.visible = false
		return

	label.visible = true

	if not unlocked:
		label.text = locked_text
		return

	if not both_in_range:
		label.text = waiting_text
		return

	label.text = exit_text
	transfer_to_main_menu()


func transfer_to_main_menu():
	if transferring:
		return

	transferring = true

	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(main_menu_scene)


func set_texture(unlocked: bool, in_range: bool):
	if unlocked:
		if in_range:
			if open_inrange_texture:
				sprite.texture = open_inrange_texture
		else:
			if open_texture:
				sprite.texture = open_texture
	else:
		if in_range:
			if closed_inrange_texture:
				sprite.texture = closed_inrange_texture
		else:
			if closed_texture:
				sprite.texture = closed_texture
