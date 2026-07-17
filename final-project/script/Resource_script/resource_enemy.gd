extends Resource
class_name enemy_resource

@export var enemy_name: String
@export var weak: weakness
@export var resist:resistance
@export var enemy_atk:int = 1
@export var enemy_hp:int = 0
@export var xp_give:int = 1

enum weakness{None, Fire, Water, Electric, Wind}
enum resistance{None, Fire, Water, Electric, Wind}
