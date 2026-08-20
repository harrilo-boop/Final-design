extends Resource
class_name FloorResource

enum FloorType {
	BATTLE,
	LOGIC,
	RECOVERY,
	TREASURE,
	BOSS
}

@export var floor_number:int
@export var floor_describtion: String
@export var floor_type:FloorType
