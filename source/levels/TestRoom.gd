class_name World
extends Node2D

signal game_is_ready

# I think this script will just be for setting up stuff
var game_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	StateManager.game_room = self
	StateManager.final_setup()
	# print("all ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if StateManager.are_references_ready():
		game_ready = true
		game_is_ready.emit()
