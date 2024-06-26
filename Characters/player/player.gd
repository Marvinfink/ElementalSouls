extends "res://Characters/player/player_movement.gd"

#Handles the user input
func _input(event):
	# handle dash input
	if Input.is_action_just_pressed("dash") && dash_used:
		dash()
	# handle swing input
	if in_attack_range and Input.is_action_just_pressed("swing") and enemy_attack_cooldown == true:
		attack(damage)
	# handle special attack input
	if Input.is_action_just_pressed("special_attack") and special_attack_bar >= 5:
		special_attack()
	#change element
	if Input.is_action_just_pressed("fire"):
		element=Elements.Element.FIRE
		change_element()
	elif Input.is_action_just_pressed("water"):
		element=Elements.Element.WATER
		change_element()
	elif Input.is_action_just_pressed("electro"):
		element=Elements.Element.ELETRICITY
		change_element()
	elif Input.is_action_just_pressed("plant"):
		element=Elements.Element.PLANT
		change_element()

	#swing while walking
	if Input.is_action_just_pressed("swing") and walking:
		set_swing(true)
		animation_tree1["parameters/conditions/walk"] = true
	#swing while standing
	elif Input.is_action_just_pressed("swing") and not walking:
		set_swing(true)
		#await? get animationtree out of player.gd
		animation_tree1["parameters/conditions/idle"] = true
		
		
func _physics_process(delta):
	#walking
	direction = Input.get_vector("left","right","up","down")
	if not swing:
		velocity = direction * speed
		update_blend_position()
	else:
		velocity = Vector2.ZERO
	
	if direction != Vector2.ZERO and not swing:
		walking =true
		set_walking(walking)
		update_blend_position()
	else:
		walking=false
		set_walking(walking)
	move_and_slide()
	player_looking()
	handle_dash(delta)
