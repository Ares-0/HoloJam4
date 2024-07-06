class_name NoiseBarrier
extends StaticBody2D

@export var number: int = 0
@export var active: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/TextureRect.texture.noise.seed += number*100
	StateManager.noise_barriers[number] = self
	if active:
		activate()
	else:
		deactivate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.get_frames_drawn() % 30 == 0:
		$Control/TextureRect.texture.noise.seed += 1
		#.Texture.Noise.Seed += 1


func activate() -> void:
	self.visible = true
	$CollisionShape2D.set_deferred("disabled", false)

func deactivate() -> void:
	if number == 4:
		await get_tree().create_timer(15.0).timeout
	self.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

func set_state(state: bool) -> void:
	if state:
		activate()
	else:
		deactivate()
