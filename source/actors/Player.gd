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

