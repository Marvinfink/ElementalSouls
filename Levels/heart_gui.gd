extends Panel
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func update(show: int):
	if sprite.frame != show:
		sprite.frame = 3
		await get_tree().create_timer(0.3).timeout
		
	sprite.frame = show
	
	
