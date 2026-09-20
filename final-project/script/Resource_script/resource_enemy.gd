extends Resource
class_name enemy_resource

@export var enemy_icon: Texture2D
@export var enemy_name: String
@export var weak: weakness
@export var resist:resistance
@export var enemy_atk:int = 1
@export var enemy_hp:int = 0
@export var xp_give:int = 100
@export var appear_level: appear_floor

enum weakness{None, Fire, Water, Electric, Wind}
enum resistance{None, Fire, Water, Electric, Wind}
enum appear_floor{Range_1, Range_2, Range_3, Range_4, Range_5}
