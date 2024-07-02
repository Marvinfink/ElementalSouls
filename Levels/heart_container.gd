extends HBoxContainer

@onready var heart_gui = preload("res://Levels/heart_gui.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func set_max_hearts(health: int):
	health /= 2
	for i in range(health):
		var heart = heart_gui.instantiate()
		add_child(heart)
		heart.update(0)
	
func set_heart_bar(current_health):
	var  hearts = get_children()
	var count = 0
	
	while current_health > 0:
		if current_health >= 2:
			hearts[count].update(0)
			current_health -= 2
		elif current_health == 1:
			hearts[count].update(1)
			current_health = -1
		else:
			hearts[count].update(2)
			current_health = -1
		count += 1
		
	while count != hearts.size():
		hearts[count].update(2)
		count += 1
		
	
	
