extends "res://enemy/types/enemy_marksman.gd"

func set_type():
	$BodyMarksman.texture = preload("res://Art/pixelart/enemies/waterRanged.png")
	element = Elements.Element.WATER
