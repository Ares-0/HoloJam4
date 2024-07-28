class_name PlotPoint1a
extends State

# At this point, the player can walk around the top room
# Transition is interacting with the talisman

var pause_goal: String = "Take the talisman, then look around"

func enter():
	StateManager.set_noise_barriers([1, 1, 1, 1, 1, 1, 1, 1])
	StateManager.update_pause_goals(pause_goal)

	# only change if not already changing via animation
	if StateManager.hh_overlay.get_fade() == 1:
		StateManager.hh_overlay.set_fade(0)

func update(_delta: float):
	if true in StateManager.player.talisman_inventory:
		Transitioned.emit(self, "plotpoint1b")

func advance():
	Transitioned.emit(self, "plotpoint1b")
