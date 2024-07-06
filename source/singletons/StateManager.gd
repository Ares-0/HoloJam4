extends Node

# This singleton tracks the state of everything in the game worth tracking
# Using this info to share the exact game state
# to ensure everything acts correctly at the correct time

# TODO: Update: ok I put a lot of shit in here that doesn't belong here
# This should only have states and functions about updating the states
# and actors that we need easy access to
# Something else should be doing logic for the game
# Something that isn't an always on singleton

signal plot_progressed

const PLAYER_START: Vector2 = Vector2(278, -1808)

var inner_talisman_states = [] # array of bools, if true, inner T holder has talisman at that index
var outer_talisman_states = []

var day_num: int = 57392
var part_num: int = 0 		# part one or two of the story # potentially redundant
var plot_point: int = 0
var player_position: Vector2 = Vector2(278, -1808)
var current_state: State

# Other things everyone should have access to
# Should this go in a different singleton? Maybe
var player
var camera
var debug_ui
var hh_overlay
var pauser
var game_room
var final_door

var Ending01Player # animation player

var t_holders_inner = []
var t_holders_outer = []
var noise_barriers = []

var version_number = "1.0.1" # this is totally here temporarily

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

	# check for triggers and advance state
	if plot_point == -1:
		return

	# these being in process is weird
	if plot_point == -2:
		hh_overlay.set_fade(0)
		set_noise_barriers([0, 0, 0, 0, 0, 0, 0, 0])

	if plot_point == -3:
		show_all_dialog()

	if Input.is_action_just_pressed("debug_01"):
		pass

func on_update_holder(inner: bool, number: int, filled: bool):
	# currently assumes everything is valid
	if inner:
		inner_talisman_states[number] = filled
	else:
		outer_talisman_states[number] = filled
	update_state_string()

func update_pause_goals(new_goal: String):
	pauser.update_goal(new_goal)

func increment_day_num():
	# TODO: low pri: make it pick from a random range
	day_num += 1

func new_game() -> void:
	plot_point = 0
	part_num = 0
	day_num = 57392
	player_position = PLAYER_START

func resume() -> void:
	if plot_point >= 0:
		player.set_global_position(player_position)

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

func set_noise_barriers(new_states) -> void:
	for i in range(len(noise_barriers)):
		noise_barriers[i].set_state(new_states[i])

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
	
