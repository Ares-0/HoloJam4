class_name PauseMenu
extends Control

# Has to be low on the tree to be on top

var paused: bool = false

@onready var goal_label = $MarginContainer/CenterContainer/VBoxContainer/Goal
@onready var resume_button = $MarginContainer/CenterContainer/VBoxContainer/ResumeB

# Called when the node enters the scene tree for the first time.
func _ready():
	StateManager.pauser = self
	update_goal("")

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if paused:
			unpause()
		else:
			pause()

func pause():
	paused = true
	get_tree().paused = true
	resume_button.grab_focus()
	show()

func unpause():
	paused = false
	hide()
	get_tree().paused = false

func update_goal(text: String) -> void:
	goal_label.text = text

func _on_resume_b_pressed():
	unpause()

func _on_menu_b_pressed():
	paused = false
	StateManager.return_to_menu_prep()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://source/levels/TitleScreen.tscn")
