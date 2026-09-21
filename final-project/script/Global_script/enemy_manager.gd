extends Node
class_name enemy_manager

@export var floor_enemies: Array[enemy_resource]

func get_enemy_for_floor(floor: int) -> enemy_resource:
	if floor < 0 or floor > 50:
		return null
	var index = max(floor - 1, 0)
	if index >= floor_enemies.size():
		return null
	return floor_enemies[index]
