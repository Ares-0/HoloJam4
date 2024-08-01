class_name AudioManager
extends Node2D

# Takes in a number of variables to decide which music to play
# Player in middle area: play shiori loading music
# Player in outer areas:
#	If *outer* talisman filled, play angry tako music
#	If outer talisman empty, play minimal empty feeling music
# When moving from zone to zone, slowly switch to other music
# Be able to gracefully handle moving back and forth quickly

# TODO: what about when paused?

var current_zone: int = 0
enum MODE {CENTER, OUTER, NONE}
var mode = MODE.NONE # if center, playing center music, if outer playing outer music (according to other logic)

var balance_center: float = 0.0
var balance_outer: float = 0.0
var b_velocity_up: float = 0.25 # how quickly volume raises
var b_velocity_down: float = 0.45 # how quickly volume falls

@onready var StreamCenter = $CenterPlayer
@onready var StreamOuterA = $OuterPlayerCalm
@onready var StreamOuterB = $OuterPlayerSpooky
@onready var StreamOuter = StreamOuterA

func _ready():
	StateManager.zone_helper.connect("zone_changed", on_zone_changed)
	StateManager.connect("update_holder", on_holder_update)
	StreamCenter.playing = false
	StreamOuterA.playing = false
	StreamOuterB.playing = false
	StreamCenter.set_volume_db(-80)
	StreamOuterA.set_volume_db(-80)
	StreamOuterB.set_volume_db(-80)

func _process(delta: float):
	update_balances(delta)

func update_balances(delta: float):
	# every frame, adjust the balances of each stream

	# trend toward inner stream
	if mode == MODE.CENTER:
		# mode is maxed out? move on
		if balance_center == 1.0:
			return

		balance_outer -= b_velocity_down*delta
		if balance_outer < 0.25: # waits a bit before lifting other
			balance_center += b_velocity_up*delta

	# trend to outer stream
	if mode == MODE.OUTER:
		if balance_outer == 1.0:
			return

		balance_center -= b_velocity_down*delta
		if balance_center < 0.25:
			balance_outer += b_velocity_up*delta
	
	if mode == MODE.NONE:
		balance_outer -= b_velocity_down*delta
		balance_center -= b_velocity_down*delta

	balance_center = clampf(balance_center, 0.0, 1.0)
	balance_outer = clampf(balance_outer, 0.0, 1.0)

	# print("\nA: ", balance_center)
	# print("B: ", balance_outer)

	# pull this from options later
	var center_cap = db_to_linear(-15)
	var outer_cap = db_to_linear(-35)

	# map the ratio to the acceptable bounds of each track (depends on the song)
	# multiplying by the cap in linear effectively scales it
	var center_volume = balance_center * center_cap
	var outer_volume = balance_outer * outer_cap

	StreamCenter.set_volume_db(linear_to_db(center_volume))
	StreamOuter.set_volume_db(linear_to_db(outer_volume))
	# print("\nA: ", center_volume, "\t\tdB: ", linear_to_db(center_volume))
	# print("B: ", outer_volume, "\t\tdB: ", linear_to_db(outer_volume))
	StateManager.debug_ui.update_right_text(4, str("Balances: ", snappedf(balance_outer, 0.01), ", ", snappedf(balance_center, 0.01)))

func on_holder_update(inner: bool, number: int, filled: bool):
	# print(inner, number, filled)
	if current_zone != number or inner:
		return

	if filled:
		StreamOuter = StreamOuterB
		# StreamOuterB.set_volume_db(StreamOuterA.get_volume_db())
		StreamOuterB.set_volume_db(-80)
		StreamOuterA.set_volume_db(-80)
	else:
		StreamOuter = StreamOuterA
		# StreamOuterA.set_volume_db(StreamOuterB.get_volume_db())
		StreamOuterA.set_volume_db(-80)
		StreamOuterB.set_volume_db(-80)
	balance_outer = 0.0

func on_zone_changed(zone: int):
	current_zone = zone
	match current_zone:
		-1:
			mode = MODE.CENTER
			if not StreamCenter.is_playing():
				StreamCenter._set_playing(true)
		0:
			mode = MODE.NONE
		1, 2, 3, 4, 5, 6, 7:
			mode = MODE.OUTER
			if not StreamOuter.is_playing():
				StreamOuterA._set_playing(true)
				StreamOuterB._set_playing(true)
		_:
			return
	
	var a = balance_outer
	if current_zone > 0: # dont check holder for middle
		on_holder_update(false, current_zone, StateManager.outer_talisman_states[current_zone])
	balance_outer = a	# dont want to change this on zone change # awk
	StateManager.debug_ui.update_right_text(3, str("A Zone: ", current_zone))
