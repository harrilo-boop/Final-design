extends CharacterBody2D

var speed:float = 2500
var player: CharacterBody2D
var battle_entered_by:String = "player"

@export var attack_area_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player"):
		player = node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if not player == null:
		#look_at(player.global_position)
		#velocity = Vector2(1, 0).rotated(rotation) * speed
	pass
	
func enter_attack_area(body: Node) -> void:
	if body == self:
		return
	elif body is Player:
		attack_area_timer.start()

func leave_attack_area(body: Node2D) -> void:
	if body == self:
		return
	elif body is Player:
		attack_area_timer.stop()

func _enter_battle_enemy() -> void:
	battle_entered_by == "enemy"
	Global.battle_entered_by = battle_entered_by
	Global.last_position = global_position
	print("Enter battle by enemy")
	get_tree().call_deferred("change_scene_to_file", "res://scenes/UI_scene/In_battle.tscn")

	
