extends CharacterBody2D

var Speed: int = 60
var playerChase: bool = false
var player = null
var damage : int =30

@onready var animation_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if playerChase:
		position += (player.position - position) / Speed
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/idle"] = false
		animation_tree
		move_and_collide(Vector2.ZERO)
	else:
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/idle"] = true


func _on_enemy_hitbox_body_entered(body):
	pass
	

func _on_enemy_hitbox_body_exited(body):
	pass
	
func enemy():
	pass

func _on_detection_area_body_entered(body):
	player = body
	playerChase = true


func _on_detection_area_body_exited(body):
	player = null
	playerChase = false
