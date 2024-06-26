extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	StateManager.connect("update_holder", on_update_holder)

func on_update_holder(inner: bool, number: int, filled: bool) -> void:
	if not inner and number == 4 and not filled:
		deactivate()

func deactivate() -> void:
	$Fence.set_layer_enabled(0, false)

