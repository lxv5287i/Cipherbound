extends Node

var analyst_solved := false
var coder_solved := false

signal both_solved

func set_analyst_solved():
	if not analyst_solved:
		analyst_solved = true
		print("Analyst solved")
	check_progress()

func set_coder_solved():
	if not coder_solved:
		coder_solved = true
		print("Coder solved")
	check_progress()

func check_progress():
	if analyst_solved and coder_solved:
		print("Both solved → unlocking door")
		emit_signal("both_solved")

func reset_progress():
	analyst_solved = false
	coder_solved = false
