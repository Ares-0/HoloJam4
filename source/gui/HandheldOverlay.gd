class_name HandheldOverlay
extends Control

# The fade to black really would be better elsewhere buut
# It fits pretty nicely honestly so rolling with it

@onready var shadow_A = $ShadowA
@onready var shadow_B = $ShadowB
@onready var shadow_DU = $DPad/ShadowDU
@onready var shadow_DD = $DPad/ShadowDD
@onready var shadow_DR = $DPad/ShadowDR
@onready var shadow_DL = $DPad/ShadowDL
@onready var animplayer = $AnimationPlayer

func _ready():
	self.visible = true
	shadow_A.visible = false
	shadow_B.visible = false
	shadow_DU.visible = false
	shadow_DD.visible = false
	shadow_DR.visible = false
	shadow_DL.visible = false
	StateManager.hh_overlay = self
	set_fade(0) # set by states enter() also

func _process(_delta):
	if Input.is_action_just_pressed("action_button"):
		shadow_A.visible = true
	if Input.is_action_just_released("action_button"):
		shadow_A.visible = false

	if Input.is_action_just_pressed("move_up"):
		shadow_DU.visible = true
	if Input.is_action_just_released("move_up"):
		shadow_DU.visible = false

	if Input.is_action_just_pressed("move_down"):
		shadow_DD.visible = true
	if Input.is_action_just_released("move_down"):
		shadow_DD.visible = false

	if Input.is_action_just_pressed("move_right"):
		shadow_DR.visible = true
	if Input.is_action_just_released("move_right"):
		shadow_DR.visible = false

	if Input.is_action_just_pressed("move_left"):
		shadow_DL.visible = true
	if Input.is_action_just_released("move_left"):
		shadow_DL.visible = false

func set_fade(alpha) -> void:
	$ColorRectBlack.color.a = alpha

func get_fade() -> float:
	return $ColorRectBlack.color.a
