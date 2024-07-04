extends "res://enemy/types/enemy_tank.gd"

func set_type():
	$BodyTank.texture = preload("res://Art/pixelart/enemies/wasser_tank.png")
	element = Elements.Element.WATER
