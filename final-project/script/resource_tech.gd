extends Resource
class_name tech_resource

@export var tech_name: String
@export var ability: abilities
@export var tech_atk:int = 1
@export var tech_hp:int = 0
@export var tech_tp:int = 1

enum abilities{None, Fire, Water, Electric, Wind, support, heal}
