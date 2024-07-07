class_name CameraMain
extends Camera2D

signal change_screen()

@export var player: Player
@onready var size: Vector2i = Vector2i(720, 720) # my cropped screen size
@onready var ui_offset: Vector2i = Vector2i(-280, 0) # to center on actual screen

var current_cell: Vector2i
var nearby_bodies = [] # list of mobs on the current screen
var previous_nearby_bodies = [] # list of mobs just left screen
var screen_locked: bool = false # If true, player cannot leave the screen

func _ready():
	StateManager.camera = self
	current_cell = get_current_cell()
	update_camera_position()
	unlock_screen()

func _process(_delta):
	check_for_update()
	update_debug_string()

func check_for_update():
	var old_cell = current_cell
	current_cell = get_current_cell()
	
	if old_cell != current_cell:
		update_camera_position()
		update_player_pos()
		change_screen.emit()

		# debug output
		# update_debug_string()

func update_camera_position() -> void:
	global_position = current_cell * size + ui_offset

func update_player_pos() -> void:
	player.clamp_position_to_limits(global_position - Vector2(ui_offset), size)
	StateManager.player_position = player.global_position

func update_debug_string() -> void:
	if StateManager.debug_ui != null and StateManager.debug_ui.visible:
		StateManager.debug_ui.update_right_text(1, str(current_cell))
		StateManager.debug_ui.update_right_text(2, str(StateManager.player.global_position))
		StateManager.debug_ui.update_left_text(4, str(nearby_bodies))

func get_current_cell() -> Vector2i:
	var last: Vector2 = player.global_position / Vector2(size)
	# fix so negative numbers work
	if last.x < 0:
		last.x -= 1
	if last.y < 0:
		last.y -= 1
	return Vector2i(last)

func lock_screen():
	$ScreenLockShape.collision_layer = 1
	screen_locked = true

func unlock_screen():
	$ScreenLockShape.collision_layer = 20
	screen_locked = false

func toggle_lock_screen():
	if screen_locked:
		unlock_screen()
	else:
		lock_screen()

func _on_area_2d_body_entered(body):
	#print(Engine.get_frames_drawn(), "\t", body, body.get_parent())
	if body is Enemy:
		body.activate()

func _on_area_2d_body_exited(body):
	if body is Enemy:
		body.deactivate()
