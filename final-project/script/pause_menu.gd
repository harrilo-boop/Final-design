extends Control

func _resume() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/overworld.tscn")
