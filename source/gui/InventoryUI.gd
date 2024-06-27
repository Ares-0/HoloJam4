extends Control

@onready var T00 = $VBoxContainer/Sprites/T00
@onready var T01 = $VBoxContainer/Sprites/T01
@onready var T02 = $VBoxContainer/Sprites/T02
@onready var T03 = $VBoxContainer/Sprites/T03
@onready var T04 = $VBoxContainer/Sprites/T04
@onready var T05 = $VBoxContainer/Sprites/T05
@onready var T06 = $VBoxContainer/Sprites/T06
@onready var T07 = $VBoxContainer/Sprites/T07

# Called when the node enters the scene tree for the first time.
func _ready():
	StateManager.connect("update_holder", on_update_holder)

func on_update_holder(_inner, _number, _filled) -> void:
	var ref = StateManager.player.talisman_inventory
	await get_tree().process_frame
	T00.visible = ref[0]
	T01.visible = ref[1]
	T02.visible = ref[2]
	T03.visible = ref[3]
	T04.visible = ref[4]
	T05.visible = ref[5]
	T06.visible = ref[6]
	T07.visible = ref[7]
