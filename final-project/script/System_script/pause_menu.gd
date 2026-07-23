extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_find_last_scene()

func _resume() -> void:
	_find_last_scene()
	
func _quit() -> void:
	get_tree().quit()

func _find_last_scene() -> void:
	var find_scene = Global.last_scene
	if find_scene == "overworld":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/map_scene/overworld.tscn")
	elif find_scene == "Town":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/map_scene/Town.tscn")
	elif find_scene == "WeaponShop":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/map_scene/WeaponShop.tscn")
	elif find_scene == "TechniqueShop":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/map_scene/TechniqueShop.tscn")
	elif find_scene == "ItemShop":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/map_scene/ItemShop.tscn")
