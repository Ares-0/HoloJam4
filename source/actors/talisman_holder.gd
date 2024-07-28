class_name TalismanHolder
extends Node2D

# A place that can hold or receive talismans
@export var filled: bool = false # is it holding a talisman
@export var inner: bool = false # flag if this is inner or outer holder
@export var holder_number: int = 0 # what number holder this is
var talisman_number: int = 0 # what talisman it's actually holding
# half of the t holders SHOULD start with a particular talisman number, for plot
# If they get swapped around and mixed up thats fine, but the start is deterministic

# If a holder is locked, interacting with it will not remove the talisman
var locked: bool = false

@onready var debug_label = $DebugLabel

func _ready():
	# update the object references
	if inner:
		StateManager.t_holders_inner[holder_number] = self
	else:
		StateManager.t_holders_outer[holder_number] = self

	# Inform manager of current state
	# this can be overwritten by the manager
	talisman_number = holder_number
	update_sprites()
	StateManager.update_holder.emit(inner, holder_number, filled)

func _process(_delta):
	pass
	# update_debug_label()

func reset(fill: bool):
	talisman_number = holder_number
	filled = fill
	update_sprites()
	StateManager.update_holder.emit(inner, holder_number, filled)

func update_debug_label():
	var b = "F"
	if filled:
		b = "T"
	debug_label.text = str(holder_number, "   ", b, "   ", talisman_number)

func set_holder(fill: bool):
	# in theory, something setting should know the state, so no need to send the signal back
	talisman_number = holder_number
	filled = fill
	update_sprites()

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

func receive_talisman(num) -> int:
	# at some plot points, dont accept talisman
	var curr_state = StateManager.current_state

	# day 1, dont refill outer holders
	if curr_state is PlotPoint1b or curr_state is PlotPoint2 or curr_state is PlotPoint3:
		if talisman_number in [0, 2, 4, 6]:
			if not filled and not inner:
				DialogBus.display_dialog.emit("t_holder_empty_ok")
				return -1
	
	# day 2, dont refill inner holders
	if curr_state is PlotPoint6 or curr_state is PlotPoint7:
		if not filled and inner:
			DialogBus.display_dialog.emit("talisman_bad")
			return -1
		# day 2 special dialog
		if not inner:
			match num: # matching dialog to a specific talisman, not a specific holder :|
				0:
					DialogBus.display_dialog.emit("talisman_00")
				1:
					DialogBus.display_dialog.emit("talisman_01")
				3:
					DialogBus.display_dialog.emit("talisman_03")
				5:
					DialogBus.display_dialog.emit("talisman_05")
				7:
					DialogBus.display_dialog.emit("talisman_07")
				_:
					DialogBus.display_text.emit("A talisman, or rather a work of art")

	# Mid ending, just cancel
	if curr_state is PlotPoint9:
		return -1

	# receive work
	talisman_number = num
	filled = true
	update_sprites()
	# is there ever I case where I would want to know the talisman number
	# and not the holder number??
	# StateManager.update_holder.emit(inner, talisman_number, filled)
	StateManager.update_holder.emit(inner, holder_number, filled)
	$AudioDown.play()
	return num

func give_talisman() -> int:	
	# plot specific dialog
	if StateManager.current_state is PlotPoint1a:
		DialogBus.display_dialog.emit("plot_1_talisman")
		# just advance here?
	if StateManager.current_state is PlotPoint2:
		if talisman_number in [0, 2, 4, 6] and not inner:
			DialogBus.display_dialog.emit("plot_2_talisman")
			StateManager.current_state.advance()
	if StateManager.current_state is PlotPoint5:
		DialogBus.display_dialog.emit("plot_5_talisman")
		StateManager.current_state.advance()
		return -1

	var curr_state = StateManager.current_state
	# Day 1, don't pick up inner talismans
	if curr_state is PlotPoint1b or curr_state is PlotPoint2 or curr_state is PlotPoint3:
		match talisman_number:
			1, 3, 5, 7:
				DialogBus.display_dialog.emit("talisman_generic")
				return -1

	# Day 2
	if curr_state is PlotPoint6 or curr_state is PlotPoint7 or curr_state is PlotPoint8:
		# inner generic dialog
		if inner:
			DialogBus.display_dialog.emit("talisman_unknown")
		# Outer dont pick up, special dialog
		else:
			match talisman_number:
				0:
					DialogBus.display_dialog.emit("talisman_00")
				1:
					DialogBus.display_dialog.emit("talisman_01")
				3:
					DialogBus.display_dialog.emit("talisman_03")
				5:
					DialogBus.display_dialog.emit("talisman_05")
				7:
					DialogBus.display_dialog.emit("talisman_07")
				_:
					DialogBus.display_text.emit("A talisman, or rather a work of art")
			return -1

	# Mid ending, just cancel
	if curr_state is PlotPoint9:
		return -1

	# this function should have been just this stuff
	# another bigger one should've handled the logic
	filled = false
	update_sprites()
	# StateManager.update_holder.emit(inner, talisman_number, filled)
	StateManager.update_holder.emit(inner, holder_number, filled)
	$AudioUp.play()
	return talisman_number
