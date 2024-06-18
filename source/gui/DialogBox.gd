class_name DialogBox
extends CanvasLayer

@export_file ("*json") var scene_text_file

var scene_text = {}
var selected_text = []
var in_progress = false
var frame_updated = 0

@onready var background = $Background
@onready var text_label = $Background/TextLabel

func _ready():
	background.visible = false
	scene_text = load_scene_text()
	DialogBus.connect("display_dialog", on_display_dialog)

func _process(_delta):
	if in_progress:
		if Input.is_action_just_pressed("action_button"):
			# this is annoying but I dont have time rn
			if Engine.get_frames_drawn() != frame_updated:
				next_line()

func load_scene_text():
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	return JSON.parse_string(file.get_as_text())

func show_text():
	text_label.text = selected_text.pop_front()
	print()

func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func on_display_dialog(text_key: String):
	frame_updated = Engine.get_frames_drawn()
	if in_progress:
		next_line()
	else:
		# get_tree().paused = true
		background.visible = true
		in_progress = true
		selected_text = scene_text.get(text_key).duplicate()
		show_text()
		DialogBus.dialog_start.emit()

func finish():
	text_label.text = ""
	background.visible = false
	in_progress = false
	# get_tree().paused = false
	DialogBus.dialog_done.emit()
