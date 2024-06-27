class_name Enemy
extends CharacterBody2D

@export var talisman_number: int = 0 # what talisman this is linked too
# these mobs are only angry when the talisman is in the outer holder

var frame: int = 0
var active: bool = false # if on screen and performing logic
var angry: bool = false # if currently shooting words
var last_update: int = 0
var use_left_label: bool = true
var next_update: int = 20

@onready var sprites = $AnimatedSprite2D
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
		update_facing()

		# spit curses
		var current_frame: int = Engine.get_frames_drawn()
		if angry and current_frame > last_update + next_update:
			update_curses()
			last_update = current_frame
			next_update = randi_range(10, 25)

func update_facing() -> void:
	var line = StateManager.player.position.y
	if line > position.y:
		sprites.frame = frame
	else:
		sprites.frame = frame + 3

func update_curses() -> void:
	var idx = randi_range(-3, 3)
	aor.set_rotation_degrees(15*idx)
	chance_swap_label(0.9)

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

func deactivate() -> void:
	active = false
	LabelL.visible = false
	LabelR.visible = false
	# reset position and other states?
