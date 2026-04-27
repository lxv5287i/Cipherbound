extends CharacterBody2D

@export var walk_speed := 5.0
@export var tile_size := 16

var grid_position := Vector2.ZERO
var move_direction := Vector2.ZERO
var last_direction := Vector2.DOWN
var last_pressed_direction := Vector2.ZERO
var is_moving := false
var move_progress := 0.0

var current_interactable: Area2D = null

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var detector: Area2D = $InteractDetector

func _ready():
	add_to_group("coder_player")

	detector.area_entered.connect(_on_interactable_entered)
	detector.area_exited.connect(_on_interactable_exited)

	grid_position = snap_to_grid(global_position)
	global_position = grid_position
	play_idle_animation()

func _physics_process(delta):
	var dir := get_input_direction()

	if is_moving:
		move(delta)
		return

	if dir != Vector2.ZERO:
		last_direction = dir
		play_walk_animation(dir)

		if can_move(dir):
			start_move(dir)
	else:
		play_idle_animation()

func _process(_delta):
	if current_interactable and Input.is_action_just_pressed("c_interact"):
		current_interactable.interact()

func _on_interactable_entered(area: Area2D):
	if area.has_method("interact"):
		current_interactable = area

		if area.has_method("show_prompt"):
			area.show_prompt()

func _on_interactable_exited(area: Area2D):
	if area == current_interactable:
		if area.has_method("hide_prompt"):
			area.hide_prompt()

		current_interactable = null

func get_input_direction() -> Vector2:
	if Input.is_physical_key_pressed(KEY_W):
		last_pressed_direction = Vector2.UP
	elif Input.is_physical_key_pressed(KEY_S):
		last_pressed_direction = Vector2.DOWN
	elif Input.is_physical_key_pressed(KEY_A):
		last_pressed_direction = Vector2.LEFT
	elif Input.is_physical_key_pressed(KEY_D):
		last_pressed_direction = Vector2.RIGHT

	if last_pressed_direction == Vector2.UP and Input.is_physical_key_pressed(KEY_W):
		return Vector2.UP
	elif last_pressed_direction == Vector2.DOWN and Input.is_physical_key_pressed(KEY_S):
		return Vector2.DOWN
	elif last_pressed_direction == Vector2.LEFT and Input.is_physical_key_pressed(KEY_A):
		return Vector2.LEFT
	elif last_pressed_direction == Vector2.RIGHT and Input.is_physical_key_pressed(KEY_D):
		return Vector2.RIGHT

	last_pressed_direction = Vector2.ZERO
	return Vector2.ZERO

func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		round(pos.x / tile_size) * tile_size,
		round(pos.y / tile_size) * tile_size
	)

func start_move(dir: Vector2):
	move_direction = dir
	grid_position = snap_to_grid(global_position)
	global_position = grid_position
	move_progress = 0.0
	is_moving = true

func move(delta):
	move_progress += walk_speed * delta

	if move_progress >= 1.0:
		grid_position += move_direction * tile_size
		global_position = grid_position
		move_progress = 0.0
		is_moving = false

		var dir := get_input_direction()

		if dir != Vector2.ZERO:
			last_direction = dir
			play_walk_animation(dir)

			if can_move(dir):
				start_move(dir)
		else:
			play_idle_animation()
	else:
		global_position = (grid_position + move_direction * tile_size * move_progress).round()

func can_move(dir: Vector2) -> bool:
	return not test_move(global_transform, dir * tile_size)

func play_walk_animation(dir: Vector2):
	if dir == Vector2.RIGHT:
		if anim.current_animation != "walkRight":
			anim.play("walkRight", -1, 2.0)
	elif dir == Vector2.LEFT:
		if anim.current_animation != "walkLeft":
			anim.play("walkLeft", -1, 2.0)
	elif dir == Vector2.UP:
		if anim.current_animation != "walkUp":
			anim.play("walkUp", -1, 2.0)
	elif dir == Vector2.DOWN:
		if anim.current_animation != "walkDown":
			anim.play("walkDown", -1, 2.0)

func play_idle_animation():
	if last_direction == Vector2.RIGHT:
		if anim.current_animation != "idleRight":
			anim.play("idleRight")
	elif last_direction == Vector2.LEFT:
		if anim.current_animation != "idleLeft":
			anim.play("idleLeft")
	elif last_direction == Vector2.UP:
		if anim.current_animation != "idleUp":
			anim.play("idleUp")
	elif last_direction == Vector2.DOWN:
		if anim.current_animation != "idleDown":
			anim.play("idleDown")
