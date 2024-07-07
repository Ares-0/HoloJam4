class_name PlotPoint0
extends State

# At this point, the player is just spawning in
# Initial dialog automatically plays
# Transition is automatic

var pause_goal: String = "Wake up"
var in_progress: bool = false

func enter():
	# when resuming, there is a frame in which this enter is called
	# I'd rather that didn't happen, but until then, take note
	StateManager.set_noise_barriers([1, 1, 1, 1, 1, 1, 1, 1])
	StateManager.update_pause_goals(pause_goal)
	StateManager.hh_overlay.set_fade(1)
	in_progress = false

func update(_delta: float):
	if StateManager.plot_point < 0:
		return
	if in_progress:
		return

	in_progress = true
	execute_intro_one()
	await work_done
	Transitioned.emit(self, "plotpoint1a")

func execute_intro_one():
	# hh_overlay.set_fade(1)
	await get_tree().create_timer(1.0).timeout
	DialogBus.display_text.emit(str("Day ", StateManager.day_num))
	await DialogBus.dialog_done
	StateManager.hh_overlay.animplayer.play("FadeFromBlack")

	DialogBus.display_dialog.emit("plot_0_intro")
	await DialogBus.dialog_done
	work_done.emit()
