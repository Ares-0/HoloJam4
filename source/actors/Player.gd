class_name Player
extends CharacterBody2D

@export var SPEED = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass
	move(delta)

func move(_delta: float):
	pass
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
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

