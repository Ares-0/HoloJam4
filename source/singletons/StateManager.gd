extends Node

# This singleton tracks the state of everything in the game worth tracking
# Using this info to share the exact game state
# to ensure everything acts correctly at the correct time

var inner_talisman_states = [] # array of bools, if true, inner T holder has talisman at that index
var outer_talisman_states = []
var part_num: int = 0 # part one or two of the story # potentially redundant
var plot_point: int = 0 # what part of the story the player is on
var day_num: int = 57392

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

	# then fill them with their real values


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.get_frames_drawn() % 60 == 0:
		# print_state_string()
		pass
	
	# check for triggers and advance state
	if plot_point == -1:
		return
	if plot_point == 0:
		DialogBus.display_text.emit(str("Day ", day_num, " of the nightmares"))
		DialogBus.display_dialog.emit("plot_0_intro")
		plot_point += 1

func on_update_holder(inner: bool, number: int, filled: bool):
	# print("updating holder")
	# currently assumes everything is valid
	if inner:
		inner_talisman_states[number] = filled
	else:
		outer_talisman_states[number] = filled

func print_state_string():
	# return a string format of current state
	var last = ""
	last += str(Engine.get_frames_drawn(), ":\n\t")
	last += str("ti: ", inner_talisman_states, "\n\t")
	last += str("to: ", outer_talisman_states, "\n\t")
	last += str("part: ", part_num, "\t\tplot_point: " , plot_point, "\n\t")

	print(last)
