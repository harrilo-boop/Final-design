extends Area2D
class_name Door

@export var door_tag: String
@export var level_to_load: String
@export var destination_tag: String
@export var spawn: Marker2D

var player_is_blocked: bool = false

func _ready() -> void:
	add_to_group("doors")

func _on_player_entered(body: Node2D) -> void:
	if player_is_blocked:
		return
	if !body.is_in_group("player"):
		return
	if NavigationManager.player_is_transitioning:
		return
	NavigationManager.go_to_level(
		level_to_load,
		destination_tag
	)

func disable_for_player(player: Node2D) -> void:
	player_is_blocked = true
	if !body_exited.is_connected(_on_player_left_door):
		body_exited.connect(_on_player_left_door)
func _on_player_left_door(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	player_is_blocked = false
	body_exited.disconnect(_on_player_left_door)
