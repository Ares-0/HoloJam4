class_name Oddity
extends Node2D

# Actor scene representing the oddity character
# reeeally all this has to do is talk a bit then get "picked up"
# Then talk a bit more later

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func converse():
	if StateManager.plot_point == 1:
		DialogBus.display_dialog.emit("plot_1_oddity_debug")
		StateManager.increment_plot_point()
	if StateManager.plot_point == 6:
		DialogBus.display_dialog.emit("plot_1_oddity_debug")
		StateManager.increment_plot_point()

func _on_area_2d_area_entered(area):
	# print(area.get_parent())
	if area.get_parent() is Player:
		converse()


