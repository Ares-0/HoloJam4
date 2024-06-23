class_name DebugInfo
extends CanvasLayer

var left_strings = []
var right_strings = []

func _ready():
	StateManager.debug_ui = self
	self.visible = true
	right_strings.resize(8)

# These might grow in complexity over time
func update_left_text(text: String) -> void:
	$LabelA.text = text

func update_right_text(row: int, text: String) -> void:
	right_strings[row] = text
	var last = ""
	for t in right_strings:
		last = last + str(t) + "\n"

	$LabelB.text = last
