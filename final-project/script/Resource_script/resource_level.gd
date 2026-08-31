extends Resource
class_name level_resource

enum FloorType {
	NONE,
	BATTLE,
	RECOVERY,
	TREASURE,
	BOSS
}

@export var floor_number:int
@export var floor_describtion: String
@export var floor_type:FloorType
@export var enemy_group: Array
@export var reward: Array
