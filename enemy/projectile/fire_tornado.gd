extends Area2D

# Called when the node enters the scene tree for the first time.
@export var speed: float
@export var range: float
@onready var count: int = 0
var created_by_player: bool
var damage: int

# Interna
var distance_travelled: float = 0.0
var direction: Vector2 = Vector2.ZERO
var element

# Referenzen
@onready var hitbox = $Hitbox

func _ready():
	speed = 1.5
	range = randi_range(50, 100)
	element = Elements.Element.FIRE


func create(damage: int, created_by_player: bool):
	self.damage = damage
	self.created_by_player = created_by_player

func _physics_process(delta):
	if distance_travelled > range:
		self.scale *= 1.001
		$CollisionShape2D.scale *= 1.001
	else:
		var step = speed * delta * direction
		distance_travelled += step.length()
		global_position += step

func _on_body_entered(body):
	if created_by_player:
		if body.has_method("enemy"):
			body.player_attack(damage, element)
			count += 1
	else:
		if body.has_method("player"):
			body.enemy_attack()
			count += 1
	if count >= 3:
		destroy()
	
func destroy():
	queue_free()


func _on_death_timer_timeout():
	destroy()
