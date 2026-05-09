extends Node

signal analyst_solved
signal coder_solved

var analyst_done := false
var coder_done := false

func _ready():
	add_to_group("game_progress")
	print("GameProgress ready")

func solve_analyst():
	if analyst_done:
		return

	analyst_done = true
	print("GAME PROGRESS: Analyst solved")
	analyst_solved.emit()

func solve_coder():
	if coder_done:
		return

	coder_done = true
	print("GAME PROGRESS: Coder solved")
	coder_solved.emit()

func is_coder_unlocked() -> bool:
	return analyst_done

func reset_room_progress():
	analyst_done = false
	coder_done = false
	print("GAME PROGRESS: Room progress reset")
