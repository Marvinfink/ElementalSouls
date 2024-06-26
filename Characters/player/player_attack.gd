extends "res://Characters/player/base_player.gd"

var is_dashing : bool = false
var dash_speed : float = 200
var dash_duration : float = 0.2  # Dash duration in seconds
var dash_timer : float = 0
var dash_direction : Vector2 = Vector2.ZERO

func player_dash(delta):
  if is_dashing:
    dash_timer+=delta
    if dash_timer>=dash_duration:
      is_dashing=false
      dash_timer=0
      velocity=Vector2.ZERO
			
    else:
      velocity = dash_direction * dash_speed
    move_and_slide()
