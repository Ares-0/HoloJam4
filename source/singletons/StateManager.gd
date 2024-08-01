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

const PLAYER_START: Vector2 = Vector2(272, -1808)

var inner_talisman_states: Array[bool] = [] # if true, inner T holder has talisman at that index
var outer_talisman_states: Array[bool] = []

var plot_point: int = 0	# now almost useless
var day_num: int = 57392
var part_num: int = 0 		# part one or two of the story # potentially redundant
var player_position: Vector2 = Vector2(278, -1808)
var current_state: State
var state_str: StringName = ""

var save_data: game_data = game_data.new()

var resuming: bool = false	# when true, taking special care to load the world state

# a ton of references to things everyone should have access to
# Should this go in a different singleton? Maybe
var player
var camera
var debug_ui
var hh_overlay
var pauser
var game_room
var final_door
var Ending01Player # animation player
var plot_machine
var zone_helper

var t_holders_inner = []
var t_holders_outer = []
var noise_barriers = []

var version_number = "1.1.0" # this is totally here temporarily

signal update_holder(inner: bool, number: int, filled: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	# I gotta see how returning to main menu affects stuff
	# print("readying state manager")

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

	# game data structure
	save_data.reset()

	# if player != null:
	# 	player.global_position = player_position

# func _enter_tree():
# 	print("state manager entering")

func _enter_tree():
	pass
	# print("entering")

func _process(_delta):
	# print(resuming) # resuming == true for two frames

	if game_room == null or game_room.game_ready == false:
		return
	# print("ready process")

	# handle debug states
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
	update_debug_string()

func update_pause_goals(new_goal: String):
	pauser.update_goal(new_goal)

func increment_day_num():
	day_num += randi_range(1, 15)

func reset_progress() -> void:
	# called on .this before loading the world
	part_num = 0
	day_num = 57392
	player_position = PLAYER_START
	state_str = StringName()
	current_state = null
	plot_point = 0

func return_to_menu_prep() -> void:
	hh_overlay.hide()
	game_room.game_ready = false
	player_position = player.global_position
	store_save_data()

func final_setup() -> void:
	# THIS IS ALWAYS CALLED WHEN THE WORLD ENTERS THE TREE
	# ITS CALLED BASICALLY LAST
	game_room.connect("game_is_ready", on_game_is_ready)
	# print("resuming: ", resuming)
	if resuming:
		load_save_data()
		plot_machine.return_to_state(state_str)
		# propogate holder states out to the holders
		for idx in range(0, 8):
			t_holders_inner[idx].reset(inner_talisman_states[idx])
			t_holders_outer[idx].reset(outer_talisman_states[idx])

	# one of many data points that depends on if its a new game or a resumed game
	player.set_global_position(player_position)

func set_resuming() -> void:
	# called by title screen to begin resuming process
	resuming = true

func on_game_is_ready() -> void:
	resuming = false

func are_references_ready() -> bool:
	var references = [player, camera, debug_ui, hh_overlay, pauser, game_room]
	# print(references)
	if null in references:
		return false
	return true

func store_save_data() -> void:
	save_data.fill_values(day_num, part_num, state_str, player_position)
	save_data.fill_arrays(inner_talisman_states, outer_talisman_states, player.talisman_inventory)

func load_save_data() -> void:
	day_num = save_data.day
	part_num = save_data.part
	state_str = save_data.state_str
	player_position = save_data.player_position

	inner_talisman_states = save_data.inner_states.duplicate()
	outer_talisman_states = save_data.outer_states.duplicate()
	player.talisman_inventory = save_data.inventory.duplicate()

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

func update_debug_string() -> void:
	debug_ui.update_left_text(0, str(Engine.get_frames_drawn()))
	debug_ui.update_left_text(1, str("ti: ", inner_talisman_states))
	debug_ui.update_left_text(2, str("to: ", outer_talisman_states))
	debug_ui.update_left_text(3, str("part: ", part_num, "    plot_point: " , plot_point))
	debug_ui.update_right_text(0, str("inv: ", player.talisman_inventory))

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
	
