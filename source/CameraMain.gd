class_name CameraMain
extends Camera2D

@export var player: Player
@onready var size: Vector2i = Vector2i(720, 720) # my cropped screen size
@onready var ui_offset: Vector2i = Vector2i(-280, 0) # to center on actual screen

var current_cell: Vector2i

func _ready():
	current_cell = get_current_cell()
	update_position()

func _process(_delta):
	var old_cell = current_cell
	current_cell = get_current_cell()
	
	if old_cell != current_cell:
		update_position()
		player.clamp_position_to_limits(global_position - Vector2(ui_offset), size)

func update_position() -> void:
	global_position = current_cell * size + ui_offset

func get_current_cell() -> Vector2i:
	var last: Vector2 = player.global_position / Vector2(size)
	# fix so negative numbers work
	if last.x < 0:
		last.x -= 1
	if last.y < 0:
		last.y -= 1
	return Vector2i(last)
