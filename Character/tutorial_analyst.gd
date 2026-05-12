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
	close_button.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)


func interact(_player = null):
	open_popup()


func show_prompt():
	player_in_range = true
	prompt_label.visible = true
	prompt_label.text = "[SPACE]"
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
		close_button.visible = true
	else:
		submit_button.visible = true
		close_button.visible = false
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

	if a == "" and b == "":
		result_label.text = "Please input answer"
		ans1.grab_focus()
		return

	if a == correct_a and b == correct_b:
		solved = true
		result_label.text = "Hello World"

		submit_button.visible = false
		close_button.visible = true

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
