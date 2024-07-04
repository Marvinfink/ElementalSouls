extends "res://enemy/types/enemy_marksman.gd"

func set_type():
	$BodyMarksman.texture = preload("res://Art/pixelart/enemies/elektroRanged.png")
	element = Elements.Element.ELECTRICITY
