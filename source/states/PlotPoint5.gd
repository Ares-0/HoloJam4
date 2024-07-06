class_name PlotPoint5
extends State

# Player can walk around top area
# Transition is interacting with the talisman

var pause_goal: String = "Leave the talisman, then look around"

func enter():
	StateManager.update_pause_goals(pause_goal)

func advance():
	Transitioned.emit(self, "plotpoint6")
