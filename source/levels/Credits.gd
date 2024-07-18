class_name Credits
extends Control

func _ready():
	$Button.grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://source/levels/TitleScreen.tscn")
