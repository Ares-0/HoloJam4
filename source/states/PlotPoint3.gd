class_name PlotPoint3
extends State

# Player can walk around day 1 paths
# Transition is all talismans to center

var pause_goal: String = "Bring the 8 talismans to the center"
var in_progress: bool = false

func enter():
	StateManager.set_noise_barriers([0, 1, 0, 1, 0, 1, 0, 1])
	StateManager.update_pause_goals(pause_goal)
	in_progress = false

func update(_delta: float):
	if in_progress:
		return
	if not false in StateManager.inner_talisman_states:
		in_progress = true
		execute_ending_one()
		await work_done
		Transitioned.emit(self, "plotpoint4")

func execute_ending_one():
	StateManager.Ending01Player.play("Ending01")
	await StateManager.Ending01Player.animation_finished

	DialogBus.display_dialog.emit("plot_3_ending")
	await DialogBus.dialog_done

	StateManager.hh_overlay.animplayer.play("FadeToBlack")
	await StateManager.hh_overlay.animplayer.animation_finished
	DialogBus.display_dialog.emit("plot_3_ending_b")
	await DialogBus.dialog_done

	# wait a bit
	await get_tree().create_timer(1.5).timeout
 
	DialogBus.display_dialog_big.emit("plot_3_ending_c")
	await DialogBus.dialog_done

	# Setup next day
	StateManager.increment_day_num()
	StateManager.reset_talismans()
	StateManager.part_num += 1
	StateManager.player.set_position(StateManager.player.ORIGIN)
	StateManager.camera.check_for_update()
	StateManager.Ending01Player.play("reset_fires") # lmao even

	StateManager.hh_overlay.animplayer.play("FadeFromBlack")
	# hh_overlay.set_fade(0) # feels cool but feels unintentional
	await StateManager.hh_overlay.animplayer.animation_finished

	work_done.emit()
