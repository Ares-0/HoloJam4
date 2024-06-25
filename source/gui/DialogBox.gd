class_name DialogBox
extends CanvasLayer

@export_file ("*json") var scene_text_file

var scene_text = {}
var in_progress = false
var frame_updated = 0
var text_queue = []

@onready var background = $Background
@onready var text_label = $Background/Control/TextLabel
@onready var background_big = $BackgroundBig
@onready var text_label_big = $BackgroundBig/Control/TextLabel

var active_bg
var active_label

func _ready():
	background.visible = false
	background_big.visible = false
	scene_text = load_scene_text()
	DialogBus.connect("display_dialog", on_display_dialog)
	DialogBus.connect("display_text", on_display_text)
	DialogBus.connect("display_dialog_big", on_display_dialog_big)
	DialogBus.connect("display_text_big", on_display_text_big)
	self.visible = true

func _process(_delta):
	# if pausing isn't fully ready, dont accept inputs
	# If currently paused dont accept inputs
	var scene_now = get_tree().current_scene
	# complicated ramifications of thinking I'd never change scenes
	if scene_now is World :
		if StateManager.pauser == null or StateManager.pauser.paused:
			return
	if scene_now is FinalCutscene:
		pass # ?

	if in_progress:
		if Input.is_action_just_pressed("action_button"):
			# this is annoying but I dont have time rn
			if Engine.get_frames_drawn() != frame_updated:
				next_line()
	
	if in_progress and not get_tree().paused:
		get_tree().paused = true

func load_scene_text():
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	return JSON.parse_string(file.get_as_text())

func show_text():
	active_label.text = text_queue.pop_front()

func next_line():
	if text_queue.size() > 0:
		show_text()
	else:
		finish()

func finish():
	text_label.text = ""
	active_bg.visible = false
	in_progress = false
	get_tree().paused = false # turns out this is very important!
	DialogBus.dialog_done.emit()

func display():
	frame_updated = Engine.get_frames_drawn()
	if not in_progress:
		get_tree().paused = true
		active_bg.visible = true
		in_progress = true
		show_text()
		DialogBus.dialog_start.emit()

func on_display_dialog(text_key: String):
	# TODO: better error reporting about failures
	text_queue.append_array((scene_text.get(text_key)))
	active_bg = background
	active_label = text_label
	display()

func on_display_text(raw_text: String):
	text_queue.append(raw_text)
	active_bg = background
	active_label = text_label
	display()

func on_display_dialog_big(text_key: String):
	text_queue.append_array((scene_text.get(text_key)))
	active_bg = background_big
	active_label = text_label_big
	display()

func on_display_text_big(raw_text: String):
	text_queue.append(raw_text)
	active_bg = background_big
	active_label = text_label_big
	display()
