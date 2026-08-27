extends Node2D
class_name tower_room

#Determine the type of level it is and give the correct stats
@export var enemy_body: CharacterBody2D
@export var enemy_collision: CollisionShape2D
@export var treasure_area: Area2D
@export var treasure_body: CollisionShape2D
@export var treasure: CollisionShape2D
@export var enter_require: CollisionShape2D
var floor_require: bool = true

func _ready() -> void:
	enemy_body.hide()
	enemy_collision.disabled = true
	treasure_area.hide()
	treasure.disabled = true
	treasure_body.disabled = true

	floor_require = Global.floor_require
	var current_floor_data = TowerManager.get_current_floor()
	print("Current Floor: ", current_floor_data.floor_number)
	check_type(current_floor_data)

func check_type(floor: level_resource) -> void:
	match floor.floor_type:
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
	enemy_body.show()
	enemy_collision.disabled = false

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
	if Global.floor_require == true:
		enter_require.hide()
		enter_require.disabled = false
		print("Go to Next Floor Allowed")
#Door requirement problem wait for fixed
