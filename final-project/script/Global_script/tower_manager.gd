extends Node
class_name tower_manager

#Find the correct resource file of tower room
var current_floor: int = 0
var max_floor: int = 50

func get_current_floor() -> level_resource:
	var folder_path = "res://resources/Floors/"
	var files = DirAccess.get_files_at(folder_path)
	for file in files:
		if file.begins_with(str(current_floor) + "-") and file.ends_with(".tres"):
			var path = folder_path + file
			return load(path) as level_resource
	return null

#Increase the floor level everytime enter the door
func next_floor() -> void:
	if current_floor < max_floor:
		current_floor += 1
		Global.current_floor = current_floor

func return_floor() -> void:
	if current_floor < max_floor:
		current_floor -= 1
		Global.current_floor = current_floor
