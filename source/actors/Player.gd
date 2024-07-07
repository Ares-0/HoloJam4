class_name Player
extends CharacterBody2D

var talisman_inventory: Array[bool] = []
@export var SPEED: int = 450
@export var SPRINT_SCALE: float = 2.0 # debug only
var movement_frozen: bool = false # used to stop movement during dialog # feels awk
var sprinting = 0 # debug only
var ORIGIN: Vector2 = Vector2(289, -1798)

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
	if Input.is_action_just_pressed("sprint"):
		sprinting = not sprinting
	if Input.is_action_just_pressed("action_button"):
		for object in $InteractArea.get_overlapping_areas():
			# TODO: maybe only interact with one thing

			var parent = object.get_parent()
			# Ground talisman # technically doesn't happen
			if parent is Talisman:
				pickup_talisman(parent)
				break
			# T Holder
			if parent is TalismanHolder:
				interact_talisman_holder(parent)
				break

	# if Input.is_action_just_pressed("debug_02"):
	# 	debug_conjure_talisman()

	if not movement_frozen:
		move(delta)
	# print(talisman_inventory)
	# print($InteractArea.get_overlapping_areas())

func move(_delta: float):
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# squash diagonals?
	if abs(direction.x) > 0 and direction.y > 0:
		direction = Vector2(0, 1)
	if abs(direction.x) > 0 and direction.y < 0:
		direction = Vector2(0, -1)

	var total_speed = SPEED + SPEED*SPRINT_SCALE*int(sprinting)
	velocity = direction * total_speed
	# velocity.x = move_toward(velocity.x, 0, SPEED)
	# velocity.y = move_toward(velocity.y, 0, SPEED)
	choose_sprite(direction)
	move_and_slide()
	
	# if no longer moving, snap to pixel
	if direction.length_squared() == 0:
		var pos = get_position().round()
		self.set_position(pos)

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
		$AnimatedSprite2D.frame = 2
	if direction.x == 1:
		$AnimatedSprite2D.frame = 3
	# diagonals overwrite LR with UD
	if direction.y > 0.5:
		$AnimatedSprite2D.frame = 0
	if direction.y <= -0.5:
		$AnimatedSprite2D.frame = 1

func movement_freeze():
	movement_frozen = true

func movement_unfreeze(): 
	movement_frozen = false

func _on_interact_area_area_entered(_area):
	pass
	# print(area.get_parent())
	# $InteractArea.get_overlapping_areas()

func _on_interact_area_area_exited(_area):
	pass
	# print(area.get_parent())
	# $InteractArea.get_overlapping_areas()
