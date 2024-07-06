class_name PlotPoint2
extends State

# Player can walk around Day 1 paths
# Transition is picking up new talisman

var pause_goal: String = "Bring the 8 talismans to the center"

func enter():
	StateManager.set_noise_barriers([0, 1, 0, 1, 0, 1, 0, 1])
	StateManager.update_pause_goals(pause_goal)

func update(_delta: float):
	pass

func advance():
	Transitioned.emit(self, "plotpoint3")
