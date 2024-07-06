class_name PlotPoint0
extends State

# At this point, the player is just spawning in
# Initial dialog automatically plays
# Transition is automatic

var pause_goal: String = "Wake up"

func enter():
	StateManager.set_noise_barriers([1, 1, 1, 1, 1, 1, 1, 1])
	StateManager.update_pause_goals(pause_goal)

	execute_intro_one()
	await work_done
	Transitioned.emit(self, "plotpoint1a")

func update(_delta: float):
	pass

func execute_intro_one():
	# hh_overlay.set_fade(1)
	await get_tree().create_timer(1.0).timeout
	DialogBus.display_text.emit(str("Day ", StateManager.day_num))
	await DialogBus.dialog_done
	StateManager.hh_overlay.animplayer.play("FadeFromBlack")

	DialogBus.display_dialog.emit("plot_0_intro")
	await DialogBus.dialog_done
	work_done.emit()
