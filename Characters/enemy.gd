extends CharacterBody2D

var Speed: int = 60
var playerChase: bool = false
var player = null
var damage = 50
var element = 1
var live = 500
var armor = 10
var cooldown = 0
var enemy_attack_cooldown = true
var in_range = false

@onready var animation_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player1")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_range and enemy_attack_cooldown:
		attack()


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
	if body.has_method("player"):
		in_range = true
	

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		in_range = false
	
func enemy():
	pass
	
func attack():
	enemy_attack_cooldown = false
	$attack_cooldown.start()
	player.enemy_attack()

func _on_detection_area_body_entered(body):
	player = body
	playerChase = true

func _on_detection_area_body_exited(body):
	playerChase = false

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true
