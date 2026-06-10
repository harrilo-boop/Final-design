extends Control

func _battle_end() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
