extends "res://Characters/player/base_player.gd"
"""
implements player movement
- walk
- dash
- walk, dash animation
- direction
"""

# attack functions
func attack(damage):
	special_attack_bar +=1
	if enemy_attack_cooldown:
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		enemy.player_attack(damage,element)	

func special_attack():
	special_attack_bar = 0
	print("SPECIAL ATTACK")
	print(element)


# Change element and sprite texture
func change_element():
	$Sprite2D.texture = element_textures[element]

# Changes player direction to mouse position
func player_looking():	
	player_position=player_node.position
	mouse_position= get_global_mouse_position()

	player_direction=mouse_position-player_position
	player_direction=player_direction.normalized()
	$player_hitbox/CollisionPolygon2D.look_at(get_global_mouse_position())
	
	
# dash functions
func dash():
	dash_used=false
	mouse_position=get_global_mouse_position()
	dash_direction = (mouse_position - global_position).normalized()
	is_dashing=true
	dash_timer=0
	$dash_timer.start()

func handle_dash(delta):
	if is_dashing:
		dash_timer+=delta
		if dash_timer>=dash_duration:
			is_dashing=false
			dash_timer=0
			velocity=Vector2.ZERO
			
		else:
			velocity = dash_direction * dash_speed
		move_and_slide()


# swing animation
func set_swing(value = false):
	swing = value
	animation_tree1["parameters/conditions/swing"]=value

# walking animation
func set_walking(value):
	animation_tree1["parameters/conditions/walk"]=value
	animation_tree1["parameters/conditions/idle"]=not value

# set animation direction
func update_blend_position():
	animation_tree1["parameters/attack/blend_position"] = player_direction
	animation_tree1["parameters/walk/blend_position"] = player_direction
	animation_tree1["parameters/idle/blend_position"] = player_direction
