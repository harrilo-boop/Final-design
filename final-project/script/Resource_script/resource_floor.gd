extends Resource
class_name FloorResource

enum FloorType {
	BATTLE,
	PUZZLE,
	RECOVERY,
	BOSS
}

@export var floor_number:int
@export var floor_type:FloorType
