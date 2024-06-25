class_name Enemy
extends CharacterBody2D

var active: bool = false # if on screen and performing logic

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(_delta):
	if active:
		set_rotation(get_rotation() + 0.1)
		print(Engine.get_frames_drawn(), "\t", self.name, " is active, ", active)

func activate() -> void:
	active = true

func deactivate() -> void:
	active = false
	# reset position and other states?
