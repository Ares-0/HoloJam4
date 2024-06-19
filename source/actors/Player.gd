class_name Player
extends CharacterBody2D

var talisman_inventory = []
@export var SPEED: int = 400
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
	# StateManager.debug_ui.update_right_text(str("inv: ", talisman_inventory, "\n\t"))

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
			# T Holder
			if parent is TalismanHolder:
				interact_talisman_holder(parent)

	if not movement_frozen:
		move(delta)
	# print(talisman_inventory)
	# print($InteractArea.get_overlapping_areas())

func move(_delta: float):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var total_speed = SPEED + SPEED*SPRINT_SCALE*int(sprinting)
	velocity = direction * total_speed
	# velocity.x = move_toward(velocity.x, 0, SPEED)
	# velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()

func clamp_position_to_limits(limit_position: Vector2, limit_size: Vector2) -> void:
	# limit_position: top left corner of clamp rect
	# limit_size: width and height of clamp rect

	# replace player size with something programmatic
	global_position.x = clamp(global_position.x, 
			limit_position.x + 50, limit_position.x + limit_size.x - 50)
	global_position.y = clamp(global_position.y, 
			limit_position.y + 50, limit_position.y + limit_size.y - 50)

func pickup_talisman(object):
	talisman_inventory[object.talisman_number] = true
	object.pick_up()

func interact_talisman_holder(object):
	object.interact()
	# if filled, pull talisman
	# if not, place any talisman
	if object.is_filled():
		# take talisman from holder to inventory
		talisman_inventory[object.talisman_number] = true
		object.give_talisman()
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

	StateManager.debug_ui.update_right_text(str("inv: ", talisman_inventory, "\n\t"))

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
