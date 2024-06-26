extends Node2D

var Skills: Dictionary = {
	"Fireball":{
		"unlock": false,
		"level": 0
	},
	"FireTornado":{
		"unlock": false,
		"level": 0
	},
	"Plant_attack1":{
		"unlock": false,
		"level": 0
	},
	"Plant_attack2":{
		"unlock": false,
		"level": 0
	},
}

func setUnlock(skill: String, level: int):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = true
		Skills[skill]["level"] = level

func checkSkill(skill: String) -> bool:
	return Skills[skill]["unlock"]		
