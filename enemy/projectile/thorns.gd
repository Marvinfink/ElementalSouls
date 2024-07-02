extends Area2D

var created_by_player: bool
var damage
var element
@onready var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	element = Elements.Element.PLANT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func create(damage: int, created_by_player: bool):
	self.damage = damage
	self.created_by_player = created_by_player


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
