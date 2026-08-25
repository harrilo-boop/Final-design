extends Node

const SCENE_OVERWORLD = preload("res://scenes/map_scene/overworld.tscn")
const SCENE_TOWN = preload("res://scenes/map_scene/Town.tscn")
const FIRST_FLOOR = preload("res://scenes/Map_scene/TowerRoom.tscn")
const FLOOR_LEAVE = preload("res://scenes/Map_scene/TowerRoom.tscn")


var spawn_door_tag: String = ""
var player_is_transitioning: bool = false

func go_to_level(level_tag: String, destination_tag: String) -> void:
	if player_is_transitioning:
		return
	var scene_to_load: PackedScene
	match level_tag:
		"overworld":
			scene_to_load = SCENE_OVERWORLD
			Global.last_scene = "overworld"
		"Town":
			scene_to_load = SCENE_TOWN
			Global.last_scene = "Town"
		"first_floor":
			scene_to_load = FIRST_FLOOR
			Global.last_scene = "Tower_floor"
			TowerManager.next_floor()
		"next_floor":
			scene_to_load = FLOOR_LEAVE
			Global.last_scene = "Tower_floorw"
			TowerManager.next_floor()

	if scene_to_load == null:
		return
	player_is_transitioning = true
	spawn_door_tag = destination_tag
	call_deferred("_change_scene", scene_to_load)

func _change_scene(scene_to_load: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene_to_load)
	await get_tree().scene_changed
	_place_player_at_destination()

func _place_player_at_destination() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		player_is_transitioning = false
		return

	for node in get_tree().get_nodes_in_group("doors"):
		var door = node as Door
		if door == null:
			continue
		if door.door_tag != spawn_door_tag:
			continue
		door.disable_for_player(player)
		player.global_position = door.spawn.global_position
		player_is_transitioning = false
		return
	player_is_transitioning = false
