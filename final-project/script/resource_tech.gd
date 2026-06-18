extends Resource
class_name tech_resource

@export var tech_name: String
@export var abiliy: abilities
@export var tech_atk:int = 1
@export var tech_hp:int = 0
@export var tech_tp:int = 1

enum abilities{Fire, Water, Electric, Wind, support, heal}
