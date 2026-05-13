extends Node

signal analyst_solved
signal coder_solved
signal both_solved

signal room4_analyst_interactables_done
signal room4_both_done

signal room5_analyst_done
signal room5_coder_done
signal room5_drone_done
signal room5_both_done

var team_name: String = "Team 1"

var analyst_done := false
var coder_done := false

var coder_at_exit := false
var analyst_at_exit := false
var exit_signal_sent := false

var room3_unlocked := true
var room4_unlocked := true
var room5_unlocked := false

var room3_completed := false
var room4_completed := false

var room4_analyst_opened_count := 0
var room4_analyst_required_count := 2
var room4_coder_done := false
var room4_done_signal_sent := false

var room5_analyst_solved := false
var room5_coder_solved := false
var room5_drone_solved := false
var room5_done_signal_sent := false


func _ready():
	add_to_group("game_progress")


func unlock_only_room3():
	room3_unlocked = true
	room4_unlocked = false
	room5_unlocked = false


func unlock_only_room4():
	room3_unlocked = false
	room4_unlocked = true
	room5_unlocked = false


func unlock_only_room5():
	room3_unlocked = false
	room4_unlocked = false
	room5_unlocked = true


func unlock_lobby_after_room1_and_room2():
	room3_unlocked = not room3_completed
	room4_unlocked = not room4_completed
	room5_unlocked = room3_completed and room4_completed


func complete_room3():
	if room3_completed:
		return

	room3_completed = true
	room3_unlocked = false

	print("Room 3 completed")
	_check_unlock_room5()


func complete_room4():
	if room4_completed:
		return

	room4_completed = true
	room4_unlocked = false

	print("Room 4 completed")
	_check_unlock_room5()


func _check_unlock_room5():
	if room3_completed and room4_completed:
		room5_unlocked = true
		print("Room 5 unlocked")


func reset_room_progress():
	analyst_done = false
	coder_done = false
	coder_at_exit = false
	analyst_at_exit = false
	exit_signal_sent = false


func reset_room4_progress():
	room4_analyst_opened_count = 0
	room4_coder_done = false
	room4_done_signal_sent = false
	print("Room 4 progress reset")


func reset_room5_progress():
	room5_analyst_solved = false
	room5_coder_solved = false
	room5_drone_solved = false
	room5_done_signal_sent = false
	print("Room 5 progress reset")


func lock_all_rooms():
	room3_unlocked = false
	room4_unlocked = false
	room5_unlocked = false
	print("All lobby doors locked")


func full_reset():
	room3_unlocked = true
	room4_unlocked = true
	room5_unlocked = false

	room3_completed = false
	room4_completed = false

	analyst_done = false
	coder_done = false
	coder_at_exit = false
	analyst_at_exit = false
	exit_signal_sent = false

	room4_analyst_opened_count = 0
	room4_coder_done = false
	room4_done_signal_sent = false

	room5_analyst_solved = false
	room5_coder_solved = false
	room5_drone_solved = false
	room5_done_signal_sent = false

	team_name = "Team 1"
	print("Full game progress reset")


func solve_analyst():
	if analyst_done:
		return

	analyst_done = true
	print("Analyst solved")
	analyst_solved.emit()
	_check_both_solved()


func solve_coder():
	if coder_done:
		return

	coder_done = true
	print("Coder solved")
	coder_solved.emit()
	_check_both_solved()


func _check_both_solved():
	if analyst_done and coder_done:
		print("Both solved")
		both_solved.emit()
		_check_exit_ready()


func set_player_at_exit(player_name: String, value: bool):
	if player_name == "CoderPlayer":
		coder_at_exit = value

	if player_name == "AnalystPlayer":
		analyst_at_exit = value

	_check_exit_ready()


func _check_exit_ready():
	if exit_signal_sent:
		return

	if analyst_done and coder_done and coder_at_exit and analyst_at_exit:
		exit_signal_sent = true
		var main = get_tree().get_first_node_in_group("split_screen_main")
		if main:
			main.call_deferred("go_to_lobby")


func is_analyst_solved() -> bool:
	return analyst_done


func is_coder_solved() -> bool:
	return coder_done


func is_coder_unlocked() -> bool:
	return analyst_done


func room4_analyst_opened_interactable():
	room4_analyst_opened_count += 1
	print("Room 4 analyst opened count: ", room4_analyst_opened_count)

	if room4_analyst_opened_count >= room4_analyst_required_count:
		print("Room 4 analyst opened all required interactables")
		room4_analyst_interactables_done.emit()

	_check_room4_done()


func is_room4_coder_unlocked() -> bool:
	return room4_analyst_opened_count >= room4_analyst_required_count


func solve_room4_coder():
	if room4_coder_done:
		return

	room4_coder_done = true
	print("Room 4 coder solved")
	_check_room4_done()


func _check_room4_done():
	if room4_done_signal_sent:
		return

	if room4_analyst_opened_count >= room4_analyst_required_count and room4_coder_done:
		room4_done_signal_sent = true
		print("Room 4 both jobs done")
		room4_both_done.emit()
		complete_room4()


func solve_room5_analyst():
	if room5_analyst_solved:
		return

	room5_analyst_solved = true
	print("Room 5 analyst solved")
	room5_analyst_done.emit()
	_check_room5_done()


func solve_room5_coder():
	if room5_coder_solved:
		return

	room5_coder_solved = true
	print("Room 5 coder solved")
	room5_coder_done.emit()
	_check_room5_done()


func solve_room5_drone():
	if room5_drone_solved:
		return

	room5_drone_solved = true
	print("Room 5 drone solved")
	room5_drone_done.emit()
	_check_room5_done()


func is_room5_coder_unlocked() -> bool:
	return room5_analyst_solved


func _check_room5_done():
	if room5_done_signal_sent:
		return

	if room5_analyst_solved and room5_coder_solved and room5_drone_solved:
		room5_done_signal_sent = true
		print("Room 5 all jobs done")
		room5_both_done.emit()
