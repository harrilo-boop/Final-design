extends Node2D

@export var floor_type: Resource
	
func check_type(floor: level_resource) -> void:
	var floor_tag = level_resource.FloorType
	match floor_tag:
		floor.FloorType.BATTLE:
			create_battle_room()
		floor.FloorType.LOGIC:
			create_logic_room()
		floor.FloorType.RECOVERY:
			create_recovery_room()
		floor.FloorType.TREASURE:
			create_treasure_room()
		floor.FloorType.BOSS:
			create_boss_room()

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
