class_name Oddity
extends Node2D

# Actor scene representing the oddity character
# reeeally all this has to do is talk a bit then get "picked up"
# Then talk a bit more later

@onready var body = $Body

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	set_rotation(get_rotation() + delta*0.9)
	body.set_rotation(randi_range(0, 1000))

func converse():
	if StateManager.current_state is PlotPoint1b:
		DialogBus.display_dialog.emit("plot_1_oddity_debug")
		StateManager.current_state.advance()
	if StateManager.current_state is PlotPoint6:
		DialogBus.display_dialog.emit("plot_6_oddity_debug")
		StateManager.current_state.advance()

func _on_area_2d_area_entered(area):
	# print(area.get_parent())
	if area.get_parent() is Player:
		converse()
