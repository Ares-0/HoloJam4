class_name CameraMain
extends Camera2D

@export var player: Player
@onready var size: Vector2i = Vector2i(720, 720) # my cropped screen size
@onready var ui_offset: Vector2i = Vector2i(-280, 0) # to center on actual screen

var current_cell: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	update_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var old_cell = current_cell
	update_position()
	
	if old_cell != current_cell:
		player.clamp_position_to_limits(global_position, size)

func update_position() -> void:
	current_cell = Vector2i(player.global_position) / size
	global_position = current_cell * size + ui_offset
