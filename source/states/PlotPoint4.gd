class_name PlotPoint4
extends State

# Player spawns in top room and hears dialog
# Automatic transition # now that there's an enter function can probably cut these auto states

var pause_goal: String = "Wake up"

func enter():
	StateManager.set_noise_barriers([1, 1, 1, 1, 1, 1, 1, 1])
	StateManager.update_pause_goals(pause_goal)

	execute_intro_two()
	await work_done
	Transitioned.emit(self, "plotpoint5")

func execute_intro_two():
	DialogBus.display_text.emit(str("Day ", StateManager.day_num))
	DialogBus.display_dialog.emit("plot_4_intro")
	await DialogBus.dialog_done
	work_done.emit()
