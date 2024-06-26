class_name FinalCutscene
extends Node2D

@onready var sprites = $AnimatedSprite2D
@onready var animation_p = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	sprites.frame = 0
	
	# print("final cutscene active")
	play_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func play_scene():
	DialogBus.display_text_big.emit("big dialog with overlay")
	await DialogBus.dialog_done

	animation_p.play("DropHandheld")
	await animation_p.animation_finished

	DialogBus.display_text_big.emit("Fire")
	DialogBus.display_text_big.emit("Fire!")
	await DialogBus.dialog_done
	sprites.play()
	await sprites.animation_finished
	await get_tree().create_timer(0.75).timeout
	DialogBus.display_text_big.emit("Light the Fire!")
	
	end_scene()

func end_scene():
	await get_tree().create_timer(5.0).timeout
	# TODO: fade to white here
	# oo if I could make this go to the credits scene that would be cool
	get_tree().change_scene_to_file("res://source/levels/TitleScreen.tscn")
