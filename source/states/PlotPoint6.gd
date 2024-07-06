class_name PlotPoint6
extends State

# Player can walk around main area
# Transition is interacting with the oddity

var pause_goal: String = "Leave the talisman, then look around"

func enter():
	StateManager.set_noise_barriers([0, 1, 1, 1, 1, 1, 1, 1])
	StateManager.update_pause_goals(pause_goal)

func advance():
	Transitioned.emit(self, "plotpoint7")
