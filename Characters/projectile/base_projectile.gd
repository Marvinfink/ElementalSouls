extends Area2D

# Eigenschaften für das Projektil
@export var speed: int
@export var range: int
@export var damage: int
@export var stun_duration: int
@export var knockback_force: int

# Interna
var distance_travelled: float = 0.0
var direction: Vector2

# Referenzen
@onready var hitbox = $Hitbox

func _physics_process(delta):
	position += transform.x * speed * delta * direction.normalized()

func _on_Bullet_body_entered(body):
	if body.has_method("player"):
		body.enemy_attack(damage)
	queue_free()
	
