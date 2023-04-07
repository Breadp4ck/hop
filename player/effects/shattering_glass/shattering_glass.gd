extends CanvasLayer

@export var strength: float = 10000.0
@export var fade_level: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ColorRect.material.set_shader_parameter("strength", strength)
	$ColorRect.material.set_shader_parameter("fade_level", fade_level)
