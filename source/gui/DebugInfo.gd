class_name DebugInfo
extends CanvasLayer

var left_strings = []
var right_strings = []

func _ready():
	StateManager.debug_ui = self
	self.visible = true

# These might grow in complexity over time
func update_left_text(text: String) -> void:
	$LabelA.text = text

func update_right_text(text: String) -> void:
	$LabelB.text = text
