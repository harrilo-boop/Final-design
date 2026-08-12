extends Resource
class_name level_resource

@export var room_type: Type
@export var room_name: String
@export var enemy_group: Array
@export var reward: Array
@export var scene: PackedScene

enum Type{battle, logic, boss, treasure, rest}
