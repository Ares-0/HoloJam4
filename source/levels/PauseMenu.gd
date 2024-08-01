class_name PauseMenu
extends Control

# Has to be low on the tree to be on top

var paused: bool = false

@onready var goal_label = $PauseMenuUI/CenterContainer/VBoxContainer/Goal
@onready var resume_button = $PauseMenuUI/CenterContainer/VBoxContainer/ResumeB

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
	$InventoryUI.visible = true
	$PauseMenuUI.visible = true
	$OptionsMenu.visible = false
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

func _on_options_b_pressed():
	$InventoryUI.visible = false
	$PauseMenuUI.visible = false
	$OptionsMenu.visible = true
	$OptionsMenu.open(self)

func return_from_options():
	$InventoryUI.visible = true
	$PauseMenuUI.visible = true
	$OptionsMenu.visible = false
