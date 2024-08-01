class_name OptionsMenu
extends Control

@onready var slider_master = $AudioOptions/VBoxContainer/SliderMaster
@onready var slider_music = $AudioOptions/VBoxContainer/SliderMusic
@onready var slider_sfx = $AudioOptions/VBoxContainer/SliderSFX

var parent = null # yeah yeah

# Called when the node enters the scene tree for the first time.
func _ready():
	get_bus_values()
	
func get_bus_values():
	slider_master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	slider_music.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func open(calling_parent):
	parent = calling_parent # yeah yeah yeah
	get_bus_values()

func _on_apply_button_pressed():
	AudioServer.set_bus_volume_db(0, linear_to_db(slider_master.value))
	AudioServer.set_bus_volume_db(1, linear_to_db(slider_music.value))
	AudioServer.set_bus_volume_db(2, linear_to_db(slider_sfx.value))

func _on_slider_master_mouse_exited():
	release_focus()

func _on_slider_music_mouse_exited():
	release_focus()

func _on_slider_sfx_mouse_exited():
	release_focus()

func _on_close_button_pressed():
	parent.return_from_options()
