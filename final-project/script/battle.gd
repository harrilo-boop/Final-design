extends Node2D

var player_turn:bool = true
var enemy_turn:bool = false
var player_hp:int = 10
var max_hp:int = 10
var weapon_attack:int = 2
var armour_defend:int = 1
var enemy_hp: int = 5
var max_enemy_hp:int = 5
var enemy_attack:int = 1 #NOT FINISHED------------
var enemy_defend:int = 0 #NOT FINISHED--------
var total_damage_attack:int = 0
var total_damage_defend:int = 0 #NOT FINISHED-------

@export var turn_label: Label
@export var hp_ui: Label
@export var enemy_ui: Label
@export var change_turn: Timer
@export var player_bar: ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_hp = player_hp #connect the autoload data to battle
	Global.max_player_hp = max_hp
	Global.weapon_attack = weapon_attack
	Global.armour_defend = armour_defend
	Global.enemy_hp = enemy_hp
	Global.max_enemy_hp = max_enemy_hp
	Global.enemy_attack = enemy_attack
	Global.enemy_defend = enemy_defend
	player_bar.max_value = max_hp
	player_bar.value = player_hp

func _attack_choose() -> void:
	if player_turn == true and enemy_turn == false:
		if enemy_hp >= 1: #wait for more steps!!
			total_damage_attack = weapon_attack - enemy_defend
			enemy_hp = enemy_hp - total_damage_attack
			player_turn = false
			enemy_turn = true
			turn_label.text = "Enemy's Turn"
			enemy_ui.text = "Enemy HP:" + str(enemy_hp)
			change_turn.start()
		elif enemy_hp == 0:
			battle_end() 
		

func _enemy_turn() -> void:
	if enemy_turn == true and player_turn == false:
		_enemy_attack()
 
func _enemy_attack() -> void:
	if player_hp >= 1:
		player_hp -= 1
		player_bar.value = player_hp
		player_turn = true
		enemy_turn = false
		turn_label.text = "Your Turn"
		hp_ui.text = "HP:" + str(player_hp)
	elif player_hp <= 0:
		battle_end()
func player_take_damage() -> void:
	pass

func battle_end() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/battle_end.tscn")
