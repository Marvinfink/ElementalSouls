extends CharacterBody2D

var speed:int=100;

var direction : Vector2 = Vector2.ZERO
var swing : bool = false
var walking:bool=false

@onready var animation_tree = $AnimationTree

func _physics_process(_delta):
	if not swing:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func _process(_delta):
	direction = Input.get_vector("left","right","up","down")
	
	if direction != Vector2.ZERO and not swing:
		walking =true
		set_walking(walking)
		update_blend_position()
	else:
		walking=false
		set_walking(walking)
	
	if Input.is_action_just_pressed("swing") and walking:
		set_swing(true)
		#animation_tree["parameters/conditions/walk"] = true
	elif Input.is_action_just_pressed("swing") and not walking:
		set_swing(true)
		#animation_tree["parameters/conditions/idle"] = true
		
func set_swing(value = false):
	swing = value
	animation_tree["parameters/conditions/swing"] = value

func set_walking(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/idle"] = not value

func update_blend_position():
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/walk/blend_position"] = direction

