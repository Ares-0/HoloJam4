class_name Player
extends CharacterBody2D

var ORIGIN: Vector2 = Vector2(289, -1798)

const MOVEMENTS = {
	'move_left': Vector2.LEFT,
	'move_right': Vector2.RIGHT,
	'move_up': Vector2.UP,
	'move_down': Vector2.DOWN
}

@export var SPEED: int = 450
@export var SPRINT_SCALE: float = 2.0 # debug only

var talisman_inventory: Array[bool] = []
var movement_frozen: bool = false # used to stop movement during dialog # feels awk
var sprinting = 0 # debug only

var input_history = [] # list of recently pressed directional buttons. Always listen to most recent press
var last_direction: Vector2 = Vector2.ZERO # last non-zero direction player moved in

var INTERACT_COOLDOWN_DURATION: float = 0.5 # max cooldown timer length in seconds
var interact_cooldown_time: float = 0.0 # timer for temporarily locking out interactions

@onready var animation_player = $AnimatedSprite2D

func _ready():
	talisman_inventory.resize(8)
	talisman_inventory.fill(false)
	DialogBus.connect("dialog_start", movement_freeze)
	DialogBus.connect("dialog_done", movement_unfreeze)
	StateManager.player = self

	# await StateManager.ready
	# await StateManager.debug_ui.ready
	# StateManager.debug_ui.update_right_text(0, str("inv: ", talisman_inventory))

func _process(delta: float):
	if interact_cooldown_time > 0:
		interact_cooldown_time -= delta
	
	if Input.is_action_just_pressed("sprint"):
		sprinting = not sprinting
	if Input.is_action_just_pressed("action_button"):
		if interact_cooldown_time > 0:
			return
		
		interact_cooldown_time = INTERACT_COOLDOWN_DURATION
		for object in $InteractArea.get_overlapping_areas():
			# The break means the player only interacts with the first thing in the list
			# Which is fine, assuming that everything is properly spaced so overlaps are minimal

			var parent = object.get_parent()
			# T Holder
			if parent is TalismanHolder:
				interact_talisman_holder(parent)
				break
			# Ground talisman # debug only
			if parent is Talisman:
				pickup_talisman(parent)
				break

	# if Input.is_action_just_pressed("debug_02"):
	# 	debug_conjure_talisman()

	for input in MOVEMENTS:
		if Input.is_action_just_pressed(input):
			input_history.append(input)
		if Input.is_action_just_released(input):
			var idx = input_history.find(input)
			if idx != -1:
				input_history.remove_at(idx)

	if not movement_frozen:
		move(delta)
	# print(talisman_inventory)
	# print($InteractArea.get_overlapping_areas())

func move(_delta: float):
	var direction: Vector2 = Vector2.ZERO
	if input_history.size() > 0:
		direction = MOVEMENTS[input_history.back()]
		last_direction = direction

	var total_speed = SPEED + SPEED*SPRINT_SCALE*int(sprinting)
	velocity = direction * total_speed

	choose_sprite(direction)
	move_and_slide()

	# if no longer moving, snap to pixel
	if direction.length_squared() == 0 and last_direction != Vector2.ZERO:
		var pos = get_position().round() # pixel snap
		pos = pos + last_direction*6 # adjusts larger snap rounding. 12 means 4 back, 12 forward
		pos = pos.snapped(Vector2(8, 8)) # looks awkward by itself
		self.set_position(pos)
		last_direction = Vector2.ZERO

func clamp_position_to_limits(limit_position: Vector2, limit_size: Vector2) -> void:
	# limit_position: top left corner of clamp rect
	# limit_size: width and height of clamp rect

	# replace player size with something programmatic
	global_position.x = clamp(global_position.x, 
			limit_position.x + 50, limit_position.x + limit_size.x - 50)
	global_position.y = clamp(global_position.y, 
			limit_position.y + 50, limit_position.y + limit_size.y - 50)

func debug_conjure_talisman():
	for i in range(len(talisman_inventory)):
		if talisman_inventory[i] == false:
			talisman_inventory[i] = true
			break
	StateManager.debug_ui.update_right_text(0, str("inv: ", talisman_inventory))

func pickup_talisman(object):
	# this doesn't have or really need any dupe checking
	talisman_inventory[object.talisman_number] = true
	object.pick_up()

func interact_talisman_holder(object):
	object.interact()
	# if filled, pull talisman
	# if not, place any talisman
	if object.is_filled():
		# take talisman from holder to inventory
		var num = object.give_talisman()
		if num >= 0: # can return -1, refusing the give
			talisman_inventory[num] = true
	else:
		# move talisman from inventory to holder
		var idx: int = talisman_inventory.find(true)
		if idx >= 0:
			talisman_inventory[idx] = false
			object.receive_talisman(idx)
		else:
			# Kinda awkward place for this but uhh
			# If I pass the players inventory to the t holder it can figure this out
			DialogBus.display_dialog.emit("t_holder_empty")

	StateManager.debug_ui.update_right_text(0, str("inv: ", talisman_inventory))

func choose_sprite(direction: Vector2) -> void:
	# left and right are shown if moving left or right
	if direction.x == -1:
		animation_player.play("shiori_left")
	if direction.x == 1:
		animation_player.play("shiori_right")
	if direction.y == 1:
		animation_player.play("shiori_down")
	if direction.y == -1:
		animation_player.play("shiori_up")

	if direction.length_squared() <= 0:
		animation_player.stop()

func movement_freeze():
	movement_frozen = true
	input_history.clear()

func movement_unfreeze(): 
	movement_frozen = false
	input_history.clear()

func _on_interact_area_area_entered(_area):
	pass
	# print(area.get_parent())
	# $InteractArea.get_overlapping_areas()

func _on_interact_area_area_exited(_area):
	pass
	# print(area.get_parent())
	# $InteractArea.get_overlapping_areas()
