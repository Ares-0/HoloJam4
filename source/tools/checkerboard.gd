@tool
extends Node2D

@export var width: int = 8
@export var height: int = 8
@export var minSizeOfSquares: int = 60
@export var alpha = 0.1
var screensize: Vector2
var col1 = Color(0.1, 0.1, 0.1, alpha)
var col2 = Color(0.9, 0.9, 0.9, alpha)

func _ready() -> void:
	screensize = Vector2(400, 400)
	
func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	var i = 0
	for x in width:
		for y in height:
			var pos = Vector2(x*minSizeOfSquares, y*minSizeOfSquares)
			var size = Vector2(minSizeOfSquares, minSizeOfSquares)
			var rect = Rect2(pos, size)
			var col = col1 if (i%2) else col2
			draw_rect(rect, col)
			i += 1
		if width % 2 == 0 and height % 2 == 0:
			i += 1
