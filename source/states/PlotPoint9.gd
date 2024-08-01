class_name PlotPoint9
extends State

# Player can walk around day 2 paths
# Transition enter door

var pause_goal: String = "Wake up... for real"

func enter():
	StateManager.set_noise_barriers([0, 0, 1, 0, 1, 0, 1, 0])
	StateManager.update_pause_goals(pause_goal)
	StateManager.hh_overlay.set_fade(0)
	StateManager.final_door.activate()

func advance():
	execute_ending_two()
	await work_done
	Transitioned.emit(self, "plotpoint10")

func execute_ending_two():
	StateManager.hh_overlay.animplayer.play("FadeToBlack")
	await StateManager.hh_overlay.animplayer.animation_finished
	
	DialogBus.display_dialog.emit("plot_9_ending")
	await DialogBus.dialog_done

	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://source/levels/FinalCutscene.tscn")

	# does code get here
	work_done.emit()
