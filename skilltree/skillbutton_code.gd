extends TextureButton
class_name SkillButton

@onready var SkillLevel = $MarginContainer/Skilllevel
@onready var SkillBranch = $Skillbranch
@onready var panel = $Panel
@export var MaxLevel:int = 1
@export var SkillName: String
static var skillpoints : int = 11

var level: int = 0:
	set(value):
		level = value
		SkillLevel.text = str(level) +"/"+ str(MaxLevel)
		


func _on_pressed() -> void:
	if skillpoints>0:
		level = min(level+1, MaxLevel)
		var SkillTree = get_tree().get_first_node_in_group("SkillTree")
		SkillTree.setUnlock(SkillName, level)
		panel.show_behind_parent = true
		skillpoints -= 1
		print(skillpoints)
		SkillBranch.default_color = Color(1, 0.07450980693102, 0.35686275362968)
		
		var skills = get_children()
		for skill in skills:
			if skill is SkillButton and level == MaxLevel:
				skill.disabled = false
	


func _ready() -> void:
	if get_parent() is SkillButton:
		SkillBranch.add_point(self.global_position + self.size/2)
		SkillBranch.add_point(get_parent().global_position + get_parent().size/2)
