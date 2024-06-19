extends Node

# This singleton tracks the state of everything in the game worth tracking
# Using this info to share the exact game state
# to ensure everything acts correctly at the correct time

var inner_talisman_states = [] # array of bools, if true, inner T holder has talisman at that index
var outer_talisman_states = []
var part_num: int = 0 # part one or two of the story # potentially redundant
var plot_point: int = -1 # what part of the story the player is on
var day_num: int = 57392

# Other things everyone should have access to
# Should this go in a different singleton? Maybe
var debug_ui
var t_holders_inner = []
var t_holders_outer = []

signal update_holder(inner: bool, number: int, filled: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	# signals
	self.connect("update_holder", on_update_holder)

	# blank all the arrays
	inner_talisman_states.resize(8)
	inner_talisman_states.fill(false)
	outer_talisman_states.resize(8)
	outer_talisman_states.fill(false)	

	t_holders_inner.resize(8)
	t_holders_outer.resize(8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# if Engine.get_frames_drawn() % 60 == 0:
	# 	var state_str = get_state_string()
	# 	# print(state_str)
	# 	debug_ui.update_left_text(state_str)

	# check for triggers and advance state
	if plot_point == -1:
		return
	if plot_point == 0:
		# any initial setup?
		DialogBus.display_text.emit(str("Day ", day_num, " of the nightmares"))
		DialogBus.display_dialog.emit("plot_0_intro")
		increment_plot_point()
	
	if plot_point == 3 and not false in inner_talisman_states:
		# If all inner talismans are full, trigger ending 1
		execute_ending_one()
		increment_plot_point()

	if plot_point == 4:
		DialogBus.display_text.emit(str("Day ", day_num, " of the nightmares"))
		DialogBus.display_dialog.emit("plot_4_intro")
		increment_plot_point()
	
	if plot_point == 7 and not false in outer_talisman_states:
		# If all outer talismans are full, trigger ending 2
		execute_ending_two()
		increment_plot_point() # lol

func on_update_holder(inner: bool, number: int, filled: bool):
	# print("updating holder")
	# currently assumes everything is valid
	if inner:
		inner_talisman_states[number] = filled
	else:
		outer_talisman_states[number] = filled
	debug_ui.update_left_text(get_state_string())

func increment_plot_point():
	# used by other actors to progress the plot
	plot_point += 1
	debug_ui.update_left_text(get_state_string())

func increment_day_num():
	# TODO: make it pick from a random range
	day_num += 1

func execute_ending_one():
	DialogBus.display_text.emit(str("You have cast away the nightmares... for now"))
	increment_day_num()
	reset_talismans()
	part_num += 1

func execute_ending_two():
	DialogBus.display_text.emit(str("Fire fire light the fire"))

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
