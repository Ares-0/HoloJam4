class_name TalismanHolder
extends Node2D

# A place that can hold or receive talismans
@export var filled: bool = false # is it holding a talisman
@export var number: int = 0 # what number talisman
@export var inner: bool = false # flag if this is inner or outer holder

func _ready():
	update_sprites()
	StateManager.update_holder.emit(inner, number, filled)

func _process(_delta):
	pass

func is_filled():
	return filled

func update_sprites() -> void:
	if not filled:
		$SpriteMain.visible = true
		$SpritesT.visible = false
	else:
		$SpriteMain.visible = false
		$SpritesT.frame = number
		$SpritesT.visible = true

func interact():
	# this is called on every interaction for common functions
	pass
	if not filled:
		DialogBus.display_dialog.emit("t_holder_empty")

func receive_talisman(num) -> void:
	number = num
	filled = true
	update_sprites()

func give_talisman() -> int:
	filled = false
	update_sprites()
	return number
