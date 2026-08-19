extends Node2D



func _ready() -> void:
	var floor_type = TowerManager.get_floor_type(TowerManager.current_floor)
	match floor_type:
		TowerManager.FloorType.BATTLE:
			create_battle_room()
		TowerManager.FloorType.PUZZLE:
			create_puzzle_room()
		TowerManager.FloorType.RECOVERY:
			create_recovery_room()
		TowerManager.FloorType.BOSS:
			create_boss_room()

func create_battle_room():
	print("Battle Room")

func create_puzzle_room():
	print("Puzzle Room")

func create_recovery_room():
	print("Recovery Room")
	
func create_boss_room():
	print("Boss Room")
