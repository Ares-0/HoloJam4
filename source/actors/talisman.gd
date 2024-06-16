class_name Talisman
extends Node2D

# Mostly just an object that can be picked up and put down
# some visual logic in here

# what number talisman this is
# used for logic and visual reasons
@export var number: int = 0

func _ready():
	$Sprites.frame = number


func _process(_delta):
	pass

func pick_up() -> void:
	queue_free()
	# is that it?
