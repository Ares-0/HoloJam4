extends Node

# This singleton tracks the state of everything in the game worth tracking
# Using this info to share the exact game state
# to ensure everything acts correctly at the correct time

# TODO: Update: ok I put a lot of shit in here that doesn't belong here
# This should only have states and functions about updating the states
# and actors that we need easy access to
# Something else should be doing logic for the game
# Something that isn't an always on singleton

var inner_talisman_states = [] # array of bools, if true, inner T holder has talisman at that index
var outer_talisman_states = []
var day_num: int = 57392
var part_num: int = 0 		# part one or two of the story # potentially redundant
var plot_point: int = 0
var player_position: Vector2 = Vector2(278, -1808)
var plot_in_progress: bool = false

# Other things everyone should have access to
# Should this go in a different singleton? Maybe
var player
var camera
var debug_ui
var hh_overlay
var pauser
var game_room
var final_door

var Ending01Player

var t_holders_inner = []
var t_holders_outer = []
var noise_barriers = []

var version_number = "0.5.0" # this is totally here temporarily

signal update_holder(inner: bool, number: int, filled: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	# I gotta see how returning to main menu affects stuff
	# print("readying") 

	# signals
	self.connect("update_holder", on_update_holder)
	# self.connect("change_screen", on_update_screen)

	# blank all the arrays
	inner_talisman_states.resize(8)
	inner_talisman_states.fill(false)
	outer_talisman_states.resize(8)
	outer_talisman_states.fill(false)	

	t_holders_inner.resize(8)
	t_holders_outer.resize(8)
	noise_barriers.resize(8)

	# if player != null:
	# 	player.global_position = player_position

# func _enter_tree():
# 	print("state manager entering")

func _process(_delta):
	# if Engine.get_frames_drawn() % 60 == 0:

	# Ok so in hindsight, a lot of this should not have been so automatic
	# So, gotta make sure stuff is actually ready
	# await self.ready

	if debug_ui == null: # awk
		return
	
	if game_room == null:
		return
	if game_room.game_ready == false:
		return
	# update_state_string()
	# check for triggers and advance state
	if plot_point == -1:
		return

	if plot_point == -2:
		hh_overlay.set_fade(0)
		for bar in noise_barriers:
			bar.deactivate()
	
	if plot_point == -3:
		show_all_dialog()

	# Ok so what's actually happening here is annoying
	# The awaits mean these checks are going to complete multiple times
	# And the plot points incrementing was luckily hiding bugs
	# But a flag might be prudent
	if plot_in_progress:
		return

	if plot_point == 0:
		# any initial setup?
		execute_intro_one()
	
	if plot_point == 1:
		if true in player.talisman_inventory:
			noise_barriers[0].deactivate()
		# DO NOT ADVANCE PLOT POINT
		# THIS IS WHY I NEED A REAL STATE MACHINE

	if plot_point == 3 and not false in inner_talisman_states:
		# If all inner talismans are full, trigger ending 1
		execute_ending_one()

	if plot_point == 4:
		DialogBus.display_text.emit(str("Day ", day_num, " of the nightmares"))
		DialogBus.display_dialog.emit("plot_4_intro")
		increment_plot_point()

	if plot_point == 7 and not false in outer_talisman_states:
		# If all outer talismans are full, open door
		final_door.activate()
		increment_plot_point()

	if plot_point == 8 and camera.current_cell == Vector2i(0, 1):
		DialogBus.display_dialog.emit("plot_8_ending")
		increment_plot_point()

	# ending 2 triggered from final doorway overlap

	if Input.is_action_just_pressed("debug_01"):
		# execute_ending_two()
		# if final_door.active:
		# 	final_door.deactivate()
		# else:
		# 	final_door.activate()
		get_tree().change_scene_to_file("res://source/levels/FinalCutscene.tscn")

func on_update_holder(inner: bool, number: int, filled: bool):
	# print("updating holder")
	# currently assumes everything is valid
	if inner:
		inner_talisman_states[number] = filled
	else:
		outer_talisman_states[number] = filled
	update_state_string()

func increment_plot_point(dry_run: bool = false):
	# used by other actors to setup next plot state
	# dry run is like doing the work but not changing the plot point

	if not dry_run:
		plot_point += 1

	update_state_string()

	# check if any work needs to be done for new state
	if plot_point == 2:
		# turn off part 1 barriers
		noise_barriers[2].deactivate()
		noise_barriers[4].deactivate()
		noise_barriers[6].deactivate()
	
	if plot_point == 4:
		# activate everything
		for bar in noise_barriers:
			bar.activate()
	
	if plot_point == 5:
		noise_barriers[0].activate()
	
	if plot_point == 6:
		noise_barriers[0].deactivate()
	
	if plot_point == 7:
		# turn off part 2 barriers
		noise_barriers[1].deactivate()
		noise_barriers[3].deactivate()
		noise_barriers[5].deactivate()
		noise_barriers[7].deactivate()

func increment_day_num():
	# TODO: make it pick from a random range
	day_num += 1

func execute_intro_one():
	plot_in_progress = true
	# hh_overlay.set_fade(1)
	await get_tree().create_timer(1.0).timeout
	DialogBus.display_text.emit(str("Day ", day_num, " of the nightmares"))
	await DialogBus.dialog_done
	hh_overlay.animplayer.play("FadeFromBlack")

	DialogBus.display_dialog.emit("plot_0_intro")
	
	plot_in_progress = false
	increment_plot_point()

func execute_ending_one():
	plot_in_progress = true
	Ending01Player.play("Ending01")
	await Ending01Player.animation_finished

	DialogBus.display_dialog.emit("plot_3_ending")
	await DialogBus.dialog_done

	hh_overlay.animplayer.play("FadeToBlack")
	await hh_overlay.animplayer.animation_finished
	DialogBus.display_dialog.emit("plot_3_ending_b")
	await DialogBus.dialog_done

	# wait 3 seconds
	await get_tree().create_timer(3.0).timeout

	DialogBus.display_dialog_big.emit("plot_3_ending_c")
	await DialogBus.dialog_done

	# Setup next day
	increment_day_num()
	reset_talismans()
	part_num += 1
	player.set_position(player.ORIGIN)
	camera.check_for_update()
	Ending01Player.play("reset_fires") # lmao even

	hh_overlay.animplayer.play("FadeFromBlack")
	# hh_overlay.set_fade(0) # feels cool but feels unintentional
	await hh_overlay.animplayer.animation_finished

	plot_in_progress = false
	increment_plot_point()

func execute_ending_two():
	plot_in_progress = true
	DialogBus.display_text.emit(str("Cool one liner"))
	await DialogBus.dialog_done

	hh_overlay.animplayer.play("FadeToBlack")
	await hh_overlay.animplayer.animation_finished
	
	DialogBus.display_dialog.emit("plot_9_ending")
	await DialogBus.dialog_done

	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://source/levels/FinalCutscene.tscn")

	# does code get here
	plot_in_progress = false
	increment_plot_point()

func new_game() -> void:
	plot_point = 0
	part_num = 0
	day_num = 57392

func resume() -> void:
	if plot_point >= 0:
		player.set_global_position(player_position)
	increment_plot_point(true)

func are_references_ready() -> bool:
	var references = [player, camera, debug_ui, hh_overlay, pauser, game_room]
	# print(references)
	if null in references:
		return false
	return true

func reset_talismans() -> void:
	for i in range(0, 8):
		if i in [0, 2, 4, 6]: # readability is king
			t_holders_outer[i].reset(true)
			t_holders_inner[i].reset(false)
		else:
			t_holders_outer[i].reset(false)
			t_holders_inner[i].reset(true)

func get_state_string() -> String:
	# return a string format of current state
	var last = ""
	last += str(Engine.get_frames_drawn(), ":\n\t")
	last += str("ti: ", inner_talisman_states, "\n\t")
	last += str("to: ", outer_talisman_states, "\n\t")
	last += str("part: ", part_num, "\t\tplot_point: " , plot_point, "\n\t")

	return last

func update_state_string() -> void:
	debug_ui.update_left_text(0, str(Engine.get_frames_drawn()))
	debug_ui.update_left_text(1, str("ti: ", inner_talisman_states))
	debug_ui.update_left_text(2, str("to: ", outer_talisman_states))
	debug_ui.update_left_text(3, str("part: ", part_num, "\t\tplot_point: " , plot_point))

func show_all_dialog() -> void:
	# I could make this smart or...
	DialogBus.display_dialog.emit("test")
	# DialogBus.display_dialog.emit("font_test")
	DialogBus.display_dialog.emit("t_holder_empty")
	DialogBus.display_dialog.emit("plot_0_intro")
	DialogBus.display_dialog.emit("plot_1_oddity")
	DialogBus.display_dialog.emit("plot_1_oddity_debug")
	DialogBus.display_dialog.emit("plot_2_talisman")
	DialogBus.display_dialog.emit("plot_3_ending")
	DialogBus.display_dialog.emit("plot_4_intro")
	DialogBus.display_dialog.emit("plot_5_talisman")
	DialogBus.display_dialog.emit("plot_6_oddity")
	DialogBus.display_dialog.emit("plot_6_oddity_debug")
	DialogBus.display_dialog.emit("plot_8_ending")
	DialogBus.display_dialog.emit("talisman_evil")
	DialogBus.display_dialog.emit("talisman_01")
	DialogBus.display_dialog.emit("talisman_02")
	DialogBus.display_dialog.emit("talisman_03")
	DialogBus.display_dialog.emit("talisman_04")
	DialogBus.display_dialog.emit("talisman_05")
	DialogBus.display_dialog.emit("talisman_06")
	
