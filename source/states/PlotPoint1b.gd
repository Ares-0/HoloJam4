class_name PlotPoint1b
extends State

# The player can walk around the main middle area
# Transition is talking to oddity

var pause_goal: String = "Take the talisman, then look around"

func enter():
	StateManager.set_noise_barriers([0, 1, 1, 1, 1, 1, 1, 1])
	StateManager.update_pause_goals(pause_goal)
	StateManager.hh_overlay.set_fade(0)

func update(_delta: float):
	pass

func advance():
	Transitioned.emit(self, "plotpoint2")
