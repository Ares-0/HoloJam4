class_name PauseMenu
extends Control

# Has to be low on the tree to be on top

var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	StateManager.pauser = self

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if paused:
			unpause()
		else:
			pause()

func pause():
	paused = true
	get_tree().paused = true
	show()

func unpause():
	paused = false
	hide()
	get_tree().paused = false

func _on_resume_b_pressed():
	unpause()

func _on_menu_b_pressed():
	paused = false
	StateManager.hh_overlay.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://source/levels/TitleScreen.tscn")
