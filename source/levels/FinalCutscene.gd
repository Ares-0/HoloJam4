class_name FinalCutscene
extends Node2D

var playing: bool = false

@onready var sprites = $AnimatedSprite2D
@onready var animation_b = $AnimationPlayer
@onready var animation_m = $AnimationPlayer2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	sprites.frame = 0
	#$HandheldOverlay.visible = true
	# print("final cutscene active")
	#play_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not playing:
		play_scene()

func play_scene():
	playing = true
	$RebellionMusic.play()
	DialogBus.display_text_big.emit("instead...")
	await DialogBus.dialog_done

	animation_b.play("DropHandheld")
	await animation_b.animation_finished

	DialogBus.display_text_big.emit("Day 1 of the escape")
	await DialogBus.dialog_done
	await get_tree().create_timer(0.75).timeout

	DialogBus.display_text_big.emit("Fire")
	DialogBus.display_text_big.emit("Fire!")
	await DialogBus.dialog_done
	sprites.play()
	await sprites.animation_finished
	await get_tree().create_timer(0.75).timeout
	DialogBus.display_text_big.emit("Light the Fire!")

	end_scene()

func end_scene():
	await get_tree().create_timer(2.0).timeout
	animation_b.play("FadeToBlack")
	animation_m.play("FadeMusic")
	await animation_b.animation_finished
	await animation_m.animation_finished
	await get_tree().create_timer(1.0).timeout

	get_tree().change_scene_to_file("res://source/levels/TitleScreen.tscn")
