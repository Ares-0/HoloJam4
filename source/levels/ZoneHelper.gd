class_name ZoneHelper
extends Node2D

# Basically just has a set of signals that are called as the player moves from zone to zone

signal zone_changed(zone)

# Called when the node enters the scene tree for the first time.
func _ready():
	StateManager.zone_helper = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# func get_current_zone():
# 	print(StateManager.player.)

func _on_zone_main_body_entered(body):
	if body is Player:
		zone_changed.emit(-1)

func _on_zone_0_body_entered(body):
	if body is Player:
		zone_changed.emit(0)

func _on_zone_1_body_entered(body):
	if body is Player:
		zone_changed.emit(1)

func _on_zone_2_body_entered(body):
	if body is Player:
		zone_changed.emit(2)

func _on_zone_3_body_entered(body):
	if body is Player:
		zone_changed.emit(3)

func _on_zone_4_body_entered(body):
	if body is Player:
		zone_changed.emit(4)

func _on_zone_5_body_entered(body):
	if body is Player:
		zone_changed.emit(5)

func _on_zone_6_body_entered(body):
	if body is Player:
		zone_changed.emit(6)

func _on_zone_7_body_entered(body):
	if body is Player:
		zone_changed.emit(7)
