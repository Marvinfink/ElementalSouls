extends "res://enemy/types/enemy_tank.gd"

func set_type():
	$BodyTank.texture = preload("res://Art/mystic_woods_free_2.1/enemies/elektro_tank.png")
	element = Elements.Element.ELECTRICITY
