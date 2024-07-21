class_name Enemy
extends CharacterBody2D

@export var talisman_number: int = 0 # what talisman this is linked too
# these mobs are only angry when the talisman is in the outer holder

var frame: int = 0
var active: bool = false # if on screen and performing logic
var angry: bool = false # if currently shooting words
var last_update: int = 0
var use_left_label: bool = true
var next_update: int = 20 # in hindsight I'd rather count down than up

@onready var sprite_body = $BodySprite
@onready var sprite_eyes = $EyesOrigin/EyeSprite
@onready var eyes_origin = $EyesOrigin
@onready var aor = $LabelAor
@onready var LabelL = $LabelAor/LabelLeft
@onready var LabelR = $LabelAor/LabelRight

func _ready() -> void:
	pass
	LabelL.visible = use_left_label
	LabelR.visible = !use_left_label
	chance_swap_label(0.5)
	StateManager.connect("update_holder", on_update_holder)
	get_holder_status()

func _process(_delta):
	if active:
		# face player if need be
		if StateManager.player != null:
			update_facing()
			turn_eyes()

		# spit curses
		var current_frame: int = Engine.get_frames_drawn()
		update_label_alpha()
		if angry and current_frame > last_update + next_update:
			update_curses()
			last_update = current_frame
			next_update = randi_range(25, 50)

func update_label_alpha():
	var frames_left: int = last_update + next_update - Engine.get_frames_drawn()
	var color_temp: Color = LabelL.label_settings.get_font_color()
	if frames_left < 15:
		color_temp.a = 0.1 * (frames_left-5)
	else:
		color_temp.a = 1.0
	LabelL.label_settings.set_font_color(color_temp)
	LabelR.label_settings.set_font_color(color_temp)

func update_facing() -> void:
	var line = StateManager.player.position.y
	if line > position.y:
		sprite_body.frame = frame
		sprite_eyes.visible = true
	else:
		sprite_body.frame = frame + 3
		sprite_eyes.visible = false

func turn_eyes() -> void:
	var angle = self.global_position.angle_to_point(StateManager.player.position) # rads
	var dir = round(angle / (PI/4)) * (PI/4)
	eyes_origin.set_rotation(dir)
	sprite_eyes.set_rotation(-dir)

func update_curses() -> void:
	var idx = randi_range(-3, 3)
	aor.set_rotation_degrees(15*idx)
	chance_swap_label(0.9)
	# jumble text
	LabelL.text = generate_string()
	LabelR.text = LabelL.text

func chance_swap_label(odds: float) -> void:
	var swap = randf()
	if swap > odds:
		use_left_label = !use_left_label
		LabelL.visible = use_left_label
		LabelR.visible = !use_left_label

func generate_string() -> String:
	var length = randi_range(4, 10)
	var last = ""
	for x in range(0, length):
		var letter = randi_range(0, 8)
		last = last + "!@?#$%&*~"[letter] # strings are arrays!
	return last

func get_holder_status() -> void:
	var state = StateManager.outer_talisman_states[talisman_number]
	if state:
		anger()
	else:
		unanger()

func on_update_holder(inner: bool, number: int, filled: bool) -> void:
	if number == talisman_number and not inner: # if .this cares about this update
		if filled:
			anger()
		else:
			unanger() # whats a getter # whats a setter

func anger() -> void:
	angry = true
	LabelL.visible = use_left_label
	LabelR.visible = !use_left_label
	chance_swap_label(0.5)

func unanger() -> void:
	angry = false
	LabelL.visible = false
	LabelR.visible = false

func activate() -> void:
	active = true
	if angry:
		LabelL.visible = use_left_label
		LabelR.visible = !use_left_label
		chance_swap_label(0.5)

func deactivate() -> void:
	active = false
	LabelL.visible = false
	LabelR.visible = false
	# reset position and other states?
