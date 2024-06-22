class_name TitleScreen
extends Control

@onready var VersionL = $VersionL

func _ready():
	VersionL.text = "v" + StateManager.version_number
	if StateManager.hh_overlay != null: # coming from game case?
		StateManager.hh_overlay.hide()

func _on_new_game_pressed():
	StateManager.new_game()
	get_tree().change_scene_to_file("res://source/levels/TestRoom.tscn")

func _on_continue_pressed():
	# Keep the already existing save data
	# TODO: Probably need to check if any exists first?
	get_tree().change_scene_to_file("res://source/levels/TestRoom.tscn")

func _on_quit_pressed():
	get_tree().quit()
