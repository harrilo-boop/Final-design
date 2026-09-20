extends Node2D
class_name tower_room

#Determine the type of level it is and give the correct stats
@export var enemy_body: CharacterBody2D
@export var enemy_collision: CollisionShape2D
@export var treasure_area: Area2D
@export var treasure_body: CollisionShape2D
@export var treasure: CollisionShape2D
@export var revive_area: Area2D
@export var revive_collision: CollisionShape2D
@export var revive_body: CollisionShape2D
@export var enter_require: CollisionShape2D
@export var tower_door: AnimatedSprite2D
var floor_require: bool = true

func _ready() -> void:
	enemy_body.hide()
	enemy_collision.disabled = true
	treasure_area.hide()
	treasure.disabled = true
	treasure_body.disabled = true
	revive_area.hide()
	revive_collision.disabled = true
	revive_body.disabled = true
	if Global.last_scene == "Tower_floor":
		enter_require.disabled = false
	floor_require = Global.floor_require
	if floor_require == false:
		tower_door.play("Closed")
	var current_floor_data = TowerManager.get_current_floor()
	check_type(current_floor_data)


func check_type(floor: level_resource) -> void:
	match floor.floor_type:
		level_resource.FloorType.BATTLE:
			create_battle_room()
		level_resource.FloorType.RECOVERY:
			create_recovery_room()
		level_resource.FloorType.TREASURE:
			create_treasure_room()
		level_resource.FloorType.BOSS:
			create_boss_room()
	
	requirement_check()

func create_battle_room() -> void:
	print("Battle Room")
	enemy_body.show()
	enemy_collision.disabled = false

func create_recovery_room() -> void:
	print("Recovery Room")
	revive_area.show()
	revive_collision.disabled = false
	revive_body.disabled = false

func create_treasure_room() -> void:
	print("Treasure Room")
	treasure_area.show()
	treasure.disabled = false
	treasure_body.disabled = false

func create_boss_room() -> void:
	print("Boss Room")

func requirement_check() -> void:
	if Global.floor_require == true:
		tower_door.play("Opened")
		enemy_body.hide()
		enemy_collision.disabled = true
		enter_require.hide()
		enter_require.disabled = true
		print("Go to Next Floor Allowed")
#Door requirement problem wait for fixed
