extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Scalar/AnimatedSprite2D.frame = randi_range(0, 3)
	# start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func start() -> void:
	visible = true
	$AnimationPlayer.play("fire start")
	$Scalar/AnimatedSprite2D.play("default")
