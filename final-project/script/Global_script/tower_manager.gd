extends Node

var current_floor:int = 1
const MAX_FLOOR:int = 50

enum FloorType {
	BATTLE,
	PUZZLE,
	RECOVERY,
	BOSS
}

func get_floor_type(floor_number:int) -> FloorType:

	if floor_number / 10 == 1:
		return FloorType.RECOVERY
	if floor_number / 10 == 0:
		return FloorType.BOSS
	var random_type = randi_range(0, 2)
	return random_type
