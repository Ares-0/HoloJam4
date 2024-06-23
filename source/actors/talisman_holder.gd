class_name TalismanHolder
extends Node2D

# A place that can hold or receive talismans
@export var filled: bool = false # is it holding a talisman
@export var inner: bool = false # flag if this is inner or outer holder
@export var holder_number: int = 0 # what number holder this is
@export var talisman_number: int = 0 # what talisman it's actually holding
# half of the t holders SHOULD start with a particular talisman number, for plot
# If they get swapped around and mixed up thats fine, but the start is deterministic

# If a holder is locked, interacting with it will not remove the talisman
var locked: bool = false

func _ready():
	StateManager.update_holder.emit(inner, holder_number, filled)
	talisman_number = holder_number
	update_sprites()
	
	# gross
	if inner:
		StateManager.t_holders_inner[holder_number] = self
	else:
		StateManager.t_holders_outer[holder_number] = self

func _process(_delta):
	pass

func reset(fill: bool):
	talisman_number = holder_number
	filled = fill
	update_sprites()
	StateManager.update_holder.emit(inner, holder_number, filled)

func is_filled() -> bool:
	return filled

func update_sprites() -> void:
	if not filled:
		$SpriteMain.visible = true
		$SpritesT.visible = false
	else:
		$SpriteMain.visible = false
		$SpritesT.frame = talisman_number
		$SpritesT.visible = true

func interact():
	# this is called on every interaction for common functions
	pass
	# TODO: this should only be after a certain plot point
	# if not filled:
	# 	DialogBus.display_dialog.emit("t_holder_empty")

func receive_talisman(num) -> void:
	talisman_number = num
	filled = true
	update_sprites()
	StateManager.update_holder.emit(inner, talisman_number, filled)

func give_talisman() -> int:
	# if plot point 2, play first time dialog
	if StateManager.plot_point == 2:
		DialogBus.display_dialog.emit("plot_2_talisman")
		StateManager.increment_plot_point()
	if StateManager.plot_point == 5:
		DialogBus.display_dialog.emit("plot_5_talisman")
		StateManager.increment_plot_point()
		return -1

	# Read talisman descriptions on pickup
	if StateManager.plot_point == 7 or StateManager.plot_point == 6:
		match talisman_number:
			0:
				DialogBus.display_dialog.emit("talisman_00")
				return -1
			1:
				DialogBus.display_dialog.emit("talisman_01")
				if not inner: return -1 # take from inners only
			3:
				DialogBus.display_dialog.emit("talisman_03")
				if not inner: return -1
			5:
				DialogBus.display_dialog.emit("talisman_05")
				if not inner: return -1
			7:
				DialogBus.display_dialog.emit("talisman_07")
				if not inner: return -1
			_:
				DialogBus.display_text.emit("A talisman, or rather a work of art")

	filled = false
	update_sprites()
	StateManager.update_holder.emit(inner, talisman_number, filled)
	return talisman_number
