extends Node

enum Element {
	FIRE,
	WATER,
	PLANT,
	ELETRICITY
}

var element_multipliers: Dictionary = {
										  Element.FIRE: {
											  Element.FIRE: 1.0,
											  Element.WATER: 0.5,
											  Element.PLANT: 1.5,
											  Element.ELETRICITY: 1.0
										  },
										  Element.WATER: {
											  Element.FIRE: 1.5,
											  Element.WATER: 1.0,
											  Element.PLANT: 1.0,
											  Element.ELETRICITY: 0.5
										  },
										  Element.PLANT: {
											  Element.FIRE: 0.5,
											  Element.WATER: 1.0,
											  Element.PLANT: 1.0,
											  Element.ELETRICITY: 1.5
										  },
										  Element.ELETRICITY: {
											  Element.FIRE: 1.0,
											  Element.WATER: 1.5,
											  Element.PLANT: 0.5,
											  Element.ELETRICITY: 1.0
										  }
									  }


func get_element_multiplier(attacker_element: Element, defender_element: Element) -> float:
	var multi = element_multipliers[attacker_element].get(defender_element, 1.0)
	print(multi)
	return element_multipliers[attacker_element].get(defender_element, 1.0)
