class_name PlotPoint7
extends State

# Player can walk around day 2 paths
# Transition all talismans at outer

var pause_goal: String = "Bring the 8 talismans to the outsides"

func enter():
	StateManager.set_noise_barriers([0, 0, 1, 0, 1, 0, 1, 0])
	StateManager.update_pause_goals(pause_goal)

func update(_delta: float):
	if not false in StateManager.outer_talisman_states:
		StateManager.final_door.activate()
		Transitioned.emit(self, "plotpoint8")
