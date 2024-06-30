extends Area2D

# Eigenschaften für das Projektil
@export var speed: int
@export var range: int
@export var damage: float
@export var stun_duration: int
@export var knockback_force: int

# Interna
var distance_travelled: float = 0.0

# Referenzen
@onready var hitbox = $Hitbox

func _physics_process(delta):
	if distance_travelled > range:
		destroy()
	var direction = Vector2.RIGHT.rotated(rotation)
	var step = speed * delta * direction
	distance_travelled += step.length()
	global_position += step

func _on_body_entered(body):
	if body.has_method("player"):
		return
	elif body.has_method("enemy"):
		body.player_attack(damage,Elements.get_current_element())
	destroy()
	
func destroy():
	queue_free()
