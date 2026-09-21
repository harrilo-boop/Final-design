extends Node
class_name enemy_manager

@export var floor_enemies: Array[enemy_resource]

func get_enemy_for_floor(enemy_data: enemy_resource):
	var weak = Global.weak_enemies
	if Global.current_floor < enemy_data.appear_floor:
		Global.enemy_hp = weak.enemy_hp
		print("ABCD")
	return
