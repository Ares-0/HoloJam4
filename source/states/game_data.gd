class_name game_data
extends Node

var player_position: Vector2
var inner_states: Array[bool]
var outer_states: Array[bool]
var inventory: Array[bool]

var day: int
var part: int
var state_str: StringName

func reset() -> void:
	player_position = Vector2(272, -1808)
	inner_states = [0, 1, 0, 1, 0, 1, 0, 1]
	outer_states = [1, 0, 1, 0, 1, 0, 1, 0]
	inventory = [0, 0, 0, 0, 0, 0, 0, 0]
	
	day = 57392
	part = 0
	state_str = ""

func fill_values(day_t: int, part_t: int, state: StringName, player_position_t: Vector2) -> void:
	self.day = day_t
	self.part = part_t
	self.state_str = state
	self.player_position = player_position_t

func fill_arrays(inner, outer, inventory_t) -> void:
	inner_states = inner.duplicate()
	outer_states = outer.duplicate()
	self.inventory = inventory_t.duplicate()
