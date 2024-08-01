extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var font = $Fountain
var active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	StateManager.final_door = self
	if active:
		activate()
	else:
		deactivate()

func activate():
	# door on / fountain off
	sprite.visible = true
	$CollisionShape2D.disabled = false
	font.set_layer_enabled(1, false)
	active = true

func deactivate():
	# door off / fountain on
	sprite.visible = false
	$CollisionShape2D.disabled = true
	font.set_layer_enabled(1, true)
	active = false

func _on_area_entered(area):
	if area.get_parent() == StateManager.player:
		StateManager.player.movement_freeze()
		StateManager.current_state.advance()
