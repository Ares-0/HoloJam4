extends Node2D

@onready var sprite = $Scalar/AnimatedSprite2D
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = randi_range(0, 3)
	# start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start() -> void:
	visible = true
	animation.play("fire start")
	sprite.play("default")

func end() -> void:
	visible = false
	animation.stop()
