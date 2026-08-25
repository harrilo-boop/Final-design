extends Node2D
class_name tower_room

func _ready() -> void:
	var current_floor_data = TowerManager.get_current_floor()
	if current_floor_data == null:
		print("No Floor Resource")
		return
	print("Current Floor: ", current_floor_data.floor_number)
	print("Floor Type: ", current_floor_data.floor_type)

	check_type(current_floor_data)

func check_type(floor: level_resource) -> void:
	match floor.floor_type:
		level_resource.FloorType.BATTLE:
			create_battle_room()
		level_resource.FloorType.LOGIC:
			create_logic_room()
		level_resource.FloorType.RECOVERY:
			create_recovery_room()
		level_resource.FloorType.TREASURE:
			create_treasure_room()
		level_resource.FloorType.BOSS:
			create_boss_room()
		level_resource.FloorType.NONE:
			print("Floor Type is NONE")

func create_battle_room() -> void:
	print("Battle Room")

func create_logic_room() -> void:
	print("Logic Room")

func create_recovery_room() -> void:
	print("Recovery Room")

func create_treasure_room() -> void:
	print("Treasure Room")

func create_boss_room() -> void:
	print("Boss Room")
