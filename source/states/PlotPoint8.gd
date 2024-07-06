class_name PlotPoint8
extends State

# Player can walk around day 2 paths
# Transition return to center

var pause_goal: String = "then return to the center"

func enter():
	StateManager.set_noise_barriers([0, 0, 1, 0, 1, 0, 1, 0])
	StateManager.update_pause_goals(pause_goal)
	StateManager.hh_overlay.set_fade(0)

func update(_delta: float):
	if StateManager.camera.current_cell == Vector2i(0, 1):
		DialogBus.display_dialog.emit("plot_8_ending")
		await DialogBus.dialog_done
		Transitioned.emit(self, "plotpoint9")
