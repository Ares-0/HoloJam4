class_name PlotStateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	StateManager.plot_machine = self

	# debug modes, do no state logic
	if StateManager.plot_point < 0:
		return

	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)

	if initial_state:
		current_state = initial_state
		current_state.enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.update(delta)

func on_child_transition(state, new_state_name):
	# state: state doing the transition
	# new_state_name: name of state to transition to

	# if debug states active, return
	# this is too late to catch a value passed from world
	# maybe await all ready?
	if StateManager.plot_point < 0:
		return

	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state

	StateManager.current_state = current_state
	StateManager.state_str = current_state.name
	# print("changing state to: ", StateManager.state_str)
	StateManager.update_debug_string()
	StateManager.debug_ui.update_left_text(5, str("State: ", current_state))

func return_to_state(state_str: StringName):
	# no error checking atm
	# print("returning to : ", state_str)
	var returnee = states[str(state_str.to_lower())]
	returnee.Transitioned.emit(current_state, state_str)
