extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export var solved_texture: Texture2D
@export var solved_inrange_texture: Texture2D

@export_multiline var question_text: String = ""

@export var correct_a: String = "Hello"
@export var correct_b: String = "World"

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label

@onready var popup_panel: Panel = $AnalystPopup/Panel
@onready var question_label: RichTextLabel = $AnalystPopup/Panel/Label

@onready var ans1: LineEdit = $AnalystPopup/Panel/Ans1
@onready var ans2: LineEdit = $AnalystPopup/Panel/Ans2

@onready var submit_button: TextureButton = $AnalystPopup/Panel/SubmitButton
@onready var close_button: TextureButton = $AnalystPopup/Panel/CloseButton
@onready var result_label: Label = $AnalystPopup/Panel/Result

var solved := false
var player_in_range := false


func _ready():
	add_to_group("analyst_interactable")
	add_to_group("tutorial_analyst")

	popup_panel.visible = false
	prompt_label.visible = false

	question_label.bbcode_enabled = true
	question_label.text = question_text

	result_label.text = ""

	# close button always visible and always works
	close_button.visible = true

	if normal_texture:
		sprite.texture = normal_texture

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)


func interact(_player = null):
	var level = get_tree().get_first_node_in_group("tutorial_level")

	if level == null or not level.robot_done:
		prompt_label.text = "[LOCKED]"
		return

	open_popup()


func show_prompt():
	player_in_range = true
	prompt_label.visible = true

	var level = get_tree().get_first_node_in_group("tutorial_level")

	if level != null and level.robot_done:
		prompt_label.text = "[INTERACT]"
	else:
		prompt_label.text = "[LOCKED]"

	update_texture()


func hide_prompt():
	player_in_range = false
	prompt_label.visible = false
	close_popup()
	update_texture()


func open_popup():
	popup_panel.visible = true
	GameLock.movement_locked = true

	question_label.text = question_text
	result_label.text = ""

	ans1.visible = true
	ans2.visible = true

	if solved:
		submit_button.visible = false
	else:
		submit_button.visible = true
		ans1.text = ""
		ans2.text = ""

	await get_tree().process_frame
	ans1.grab_focus()


func close_popup():
	popup_panel.visible = false
	GameLock.movement_locked = false

	ans1.release_focus()
	ans2.release_focus()


func _on_submit_pressed():
	var a := ans1.text.strip_edges()
	var b := ans2.text.strip_edges()

	# make inputs not case-sensitive
	var input_a = a.to_lower()
	var input_b = b.to_lower()

	var correct_input_a = correct_a.strip_edges().to_lower()
	var correct_input_b = correct_b.strip_edges().to_lower()

	if input_a == "" and input_b == "":
		result_label.text = "Please input answer"
		ans1.grab_focus()
		return

	# check answers
	if input_a == correct_input_a and input_b == correct_input_b:
		solved = true

		# show exactly what player typed
		result_label.text = a + " " + b

		var level = get_tree().get_first_node_in_group("tutorial_level")
		if level and level.has_method("solve_analyst"):
			level.solve_analyst()

		submit_button.visible = false

		update_texture()
		return

	result_label.text = "Try again"
	ans1.grab_focus()


func update_texture():
	if solved:
		if player_in_range and solved_inrange_texture:
			sprite.texture = solved_inrange_texture
		elif solved_texture:
			sprite.texture = solved_texture
	else:
		if player_in_range and inrange_texture:
			sprite.texture = inrange_texture
		elif normal_texture:
			sprite.texture = normal_texture
