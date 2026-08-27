extends Node2D
class_name tower_room

#Determine the type of level it is and give the correct stats
@export var treasure_area: Area2D
@export var treasure_body: CollisionShape2D
@export var treasure: CollisionShape2D
@export var enter_require: CollisionShape2D
var level_require: bool = false

func _ready() -> void:
	treasure_area.hide()
	treasure.disabled = true
	treasure_body.disabled = true
	enter_require.disabled = false
	var current_floor_data = TowerManager.get_current_floor()
	if current_floor_data == null:
		print("No Floor Resource")
		return
	print("Current Floor: ", current_floor_data.floor_number)
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

func create_battle_room() -> void:
	print("Battle Room")

func create_logic_room() -> void:
	print("Logic Room")

func create_recovery_room() -> void:
	print("Recovery Room")

func create_treasure_room() -> void:
	print("Treasure Room")
	treasure_area.show()	
	treasure.disabled = false
	treasure_body.disabled = false

func create_boss_room() -> void:
	print("Boss Room")

func requirement_check() -> void:
	if level_require == true:
		enter_require.disabled = true
		print("Go to Next Floor Allowed")
		pass
