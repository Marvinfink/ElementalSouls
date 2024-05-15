extends CharacterBody2D

var Speed: int = 60
var playerChase: bool = false
var player = null
var damage = 50
var element = 1
var health = 200
var armor = 10
var cooldown = 0
var enemy_attack_cooldown = true
var enemy_death_cooldown=false
var player_in_range = false

@onready var animation_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player1")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <=0:
		health=0
		print("enemy is died")
		animation_tree["parameters/conditions/death"] = true
		enemy_death_cooldown=true
		
	if player_in_range and enemy_attack_cooldown:
		attack()

func _physics_process(delta: float) -> void:
	if enemy_death_cooldown:
		set_process(false)
		await get_tree().create_timer(2.0).timeout
		self.queue_free()
	else:
		if playerChase:
			position += (player.position - position) / Speed
			animation_tree["parameters/conditions/is_walking"] = true
			animation_tree["parameters/conditions/idle"] = false
			animation_tree
			move_and_collide(Vector2.ZERO)
		else:
			animation_tree["parameters/conditions/is_walking"] = false
			animation_tree["parameters/conditions/idle"] = true

#check if player has entered/exited hitbox => in attack range
func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = true	
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false
	
func enemy():
	pass
	
#call enemy_attack func from player to do damage
func attack():
	enemy_attack_cooldown = false
	$attack_cooldown.start()
	player.enemy_attack(damage)

#take damage from player
func player_attack(damage):
		health = health-damage
		#print(health)

#if player in detection area => chase
func _on_detection_area_body_entered(body):
	player = body
	playerChase = true

func _on_detection_area_body_exited(body):
	playerChase = false

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true
	
