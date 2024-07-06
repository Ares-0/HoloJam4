class_name PlotPoint1a
extends State

# At this point, the player can walk around the top room
# Transition is interacting with the talisman

var pause_goal: String = "Take the talisman, then look around"

func enter():
	StateManager.update_pause_goals(pause_goal)

func update(_delta: float):
	if true in StateManager.player.talisman_inventory:
		Transitioned.emit(self, "plotpoint1b")

