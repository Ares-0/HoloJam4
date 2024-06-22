class_name TitleScreen
extends Control

@onready var VersionL = $VersionL

# Called when the node enters the scene tree for the first time.
func _ready():
	VersionL.text = "v" + StateManager.version_number


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_new_game_pressed():
	StateManager.new_game()
	get_tree().change_scene_to_file("res://source/levels/TestRoom.tscn")

func _on_continue_pressed():
	# Keep the already existing save data
	# TODO: Probably need to check if any exists first?
	get_tree().change_scene_to_file("res://source/levels/TestRoom.tscn")

func _on_quit_pressed():
	get_tree().quit()
