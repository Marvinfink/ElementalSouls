extends HBoxContainer

@onready var time_gui = preload("res://Levels/time.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func set_time_bar(current_time: int):
	var current_digits = get_children()
	var current_time_string = str(current_time)
	if current_time_string.length() != current_digits.size():
		var digit = time_gui.instantiate()
		add_child(digit)
	var count = 0
	for char in current_time_string:
		get_child(count).update(int(char))
		count += 1
	
	
