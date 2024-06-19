class_name DebugInfo
extends CanvasLayer

var left_strings = []
var right_strings = []

# Called when the node enters the scene tree for the first time.
func _ready():
	StateManager.debug_ui = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# These might grow in complexity over time
func update_left_text(text: String) -> void:
	$LabelA.text = text

func update_right_text(text: String) -> void:
	$LabelB.text = text
