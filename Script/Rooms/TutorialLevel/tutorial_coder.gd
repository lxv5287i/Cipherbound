extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export var solved_texture: Texture2D
@export var solved_inrange_texture: Texture2D

@export_multiline var question_text: String = ""

# correct answers
@export var correct_a: String = "hello"
@export var correct_b: String = "world"

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label

@onready var popup_panel: Panel = $CoderPopup/Panel
@onready var question_label: RichTextLabel = $CoderPopup/Panel/Label

@onready var ans1: LineEdit = $CoderPopup/Panel/Ans1
@onready var ans2: LineEdit = $CoderPopup/Panel/Ans2

@onready var submit_button: TextureButton = $CoderPopup/Panel/SubmitButton
@onready var close_button: TextureButton = $CoderPopup/Panel/CloseButton
@onready var result_label: Label = $CoderPopup/Panel/Result

var solved := false
var player_in_range := false


func _ready():
	add_to_group("coder_interactable")

	popup_panel.visible = false
	prompt_label.visible = false

	question_label.bbcode_enabled = true
	question_label.text = question_text

	result_label.text = ""

	# close button always works
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

	if not level.analyst_done:
		prompt_label.text = "[ANALYST FIRST]"
		return

	open_popup()


func show_prompt():
	player_in_range = true
	prompt_label.visible = true

	var level = get_tree().get_first_node_in_group("tutorial_level")

	if level == null or not level.robot_done:
		prompt_label.text = "[LOCKED]"
	elif not level.analyst_done:
		prompt_label.text = "[ANALYST FIRST]"
	else:
		prompt_label.text = "[INTERACT]"

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

	# check empty
	if a == "" and b == "":
		result_label.text = "Please input answer"
		ans1.grab_focus()
		return

	# require quotation marks
	if not a.contains("\"") or not b.contains("\""):
		result_label.text = "You need to put quotation marks (\")"
		ans1.grab_focus()
		return

	# remove spaces
	var clean_a = a.replace(" ", "")
	var clean_b = b.replace(" ", "")

	# remove quotation marks and semicolon for checking
	clean_a = clean_a.replace("\"", "").replace(";", "").to_lower()
	clean_b = clean_b.replace("\"", "").replace(";", "").to_lower()

	# correct answer check
	if clean_a == correct_a.to_lower() and clean_b == correct_b.to_lower():
		solved = true

		# remove quotation marks only
		var final_a = a.replace("\"", "").strip_edges()
		var final_b = b.replace("\"", "").strip_edges()

		# show what player typed + !
		result_label.text = final_a + " " + final_b + "!"

		var level = get_tree().get_first_node_in_group("tutorial_level")
		if level and level.has_method("solve_coder"):
			level.solve_coder()

		submit_button.visible = false

		update_texture()
		return

	result_label.text = "INCORRECT"
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
