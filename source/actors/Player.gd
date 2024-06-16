class_name Player
extends CharacterBody2D

var talisman_inventory = []
@export var SPEED: int = 300
@export var SPRINT_SCALE: float = 2.0 # debug only
var sprinting = 0 # debug only
var nearby_objects = []

func _ready():
	talisman_inventory.resize(8)
	talisman_inventory.fill(false)

func _process(delta: float):
	if Input.is_action_just_pressed("sprint"):
		sprinting = not sprinting
	if Input.is_action_just_pressed("action_button"):
		for i in range(nearby_objects.size() - 1, -1, -1):
			var object = nearby_objects[i]
			if object is Talisman:
				pickup_talisman(object)
			if object is TalismanHolder:
				interact_talisman_holder(object)
		
	move(delta)
	# print(talisman_inventory)
	# print(nearby_objects)

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
	talisman_inventory[object.number] = true
	object.pick_up()
	nearby_objects.erase(object) # doing this during the above loop is monka

func interact_talisman_holder(object):
	# if filled, pull talisman
	# if not, place any talisman
	pass
	if object.is_filled():
		# take talisman from holder to inventory
		talisman_inventory[object.number] = true
		object.give_talisman()
	else:
		# move talisman from inventory to holder
		var idx: int = talisman_inventory.find(true)
		if idx >= 0:
			talisman_inventory[idx] = false
			object.receive_talisman(idx)

func _on_interact_area_area_entered(area):
	#print("near ", area)
	nearby_objects.append(area.get_parent())
	# This is potentially awkward if multiple objects overlap
	# Will that ever actually happen? We'll see

func _on_interact_area_area_exited(area):
	#print("left ", area)
	nearby_objects.erase(area.get_parent()) # what happens if this fails?
