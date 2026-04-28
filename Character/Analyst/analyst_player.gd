extends CharacterBody2D

@export var walk_speed := 5.0
@export var tile_size := 16

var grid_position := Vector2.ZERO
var move_direction := Vector2.ZERO
var last_direction := Vector2.DOWN
var last_pressed_direction := Vector2.ZERO
var is_moving := false
var move_progress := 0.0

var nearby_interactables: Array[Area2D] = []
var current_interactable: Area2D = null

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var detector: Area2D = $InteractDetector

func _ready():
	add_to_group("analyst_player")

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
	update_current_interactable()

	if current_interactable and Input.is_action_just_pressed("a_interact"):
		current_interactable.interact()

func _on_interactable_entered(area: Area2D):
	if area.has_method("interact"):
		if not nearby_interactables.has(area):
			nearby_interactables.append(area)

func _on_interactable_exited(area: Area2D):
	if nearby_interactables.has(area):
		if area.has_method("hide_prompt"):
			area.hide_prompt()
		if area.has_method("close_popup"):
			area.close_popup()

		nearby_interactables.erase(area)

	if current_interactable == area:
		current_interactable = null

func update_current_interactable():
	if nearby_interactables.is_empty():
		current_interactable = null
		return

	var closest: Area2D = nearby_interactables[0]
	var closest_distance := global_position.distance_to(closest.global_position)

	for area in nearby_interactables:
		var distance := global_position.distance_to(area.global_position)
		if distance < closest_distance:
			closest = area
			closest_distance = distance

	if current_interactable != closest:
		if current_interactable and current_interactable.has_method("hide_prompt"):
			current_interactable.hide_prompt()

		current_interactable = closest

		if current_interactable.has_method("show_prompt"):
			current_interactable.show_prompt()

func get_input_direction() -> Vector2:
	if Input.is_physical_key_pressed(KEY_UP):
		last_pressed_direction = Vector2.UP
	elif Input.is_physical_key_pressed(KEY_DOWN):
		last_pressed_direction = Vector2.DOWN
	elif Input.is_physical_key_pressed(KEY_LEFT):
		last_pressed_direction = Vector2.LEFT
	elif Input.is_physical_key_pressed(KEY_RIGHT):
		last_pressed_direction = Vector2.RIGHT

	if last_pressed_direction == Vector2.UP and Input.is_physical_key_pressed(KEY_UP):
		return Vector2.UP
	elif last_pressed_direction == Vector2.DOWN and Input.is_physical_key_pressed(KEY_DOWN):
		return Vector2.DOWN
	elif last_pressed_direction == Vector2.LEFT and Input.is_physical_key_pressed(KEY_LEFT):
		return Vector2.LEFT
	elif last_pressed_direction == Vector2.RIGHT and Input.is_physical_key_pressed(KEY_RIGHT):
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
	else:
		global_position = (grid_position + move_direction * tile_size * move_progress).round()

func can_move(dir: Vector2) -> bool:
	return not test_move(global_transform, dir * tile_size)

func play_walk_animation(dir: Vector2):
	if dir == Vector2.RIGHT:
		anim.play("walkRight", -1, 2.0)
	elif dir == Vector2.LEFT:
		anim.play("walkLeft", -1, 2.0)
	elif dir == Vector2.UP:
		anim.play("walkUp", -1, 2.0)
	elif dir == Vector2.DOWN:
		anim.play("walkDown", -1, 2.0)

func play_idle_animation():
	if last_direction == Vector2.RIGHT:
		anim.play("idleRight")
	elif last_direction == Vector2.LEFT:
		anim.play("idleLeft")
	elif last_direction == Vector2.UP:
		anim.play("idleUp")
	elif last_direction == Vector2.DOWN:
		anim.play("idleDown")
