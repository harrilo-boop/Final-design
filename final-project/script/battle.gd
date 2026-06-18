extends Node2D
#THE SCRIPT OF PLAYER ENTER BATTLE

var player_turn:bool = true
var enemy_turn:bool = false
var update_stats:bool = false
#Player variables
var player_hp:int = 1
var max_hp:int = 1
var weapon_atk:int = 2
var armor_def:int = 1
var xp_earn:int = 1
#Enemy variables
var enemy_hp: int = 5
var max_enemy_hp:int = 5
var enemy_atk:int = 1
var enemy_def:int = 0 
#Other options button variables

#Damage calculate variables
var total_damage_atk:int = 0
var total_enemy_atk:int = 0 


@export var turn_label: Label
@export var hp_ui: Label
@export var enemy_ui: Label
@export var change_turn: Timer
@export var player_bar: ProgressBar
@export var enemy_bar: ProgressBar
#The options button of battle
@export var attack_button: Button
@export var technique_button: Button
@export var item_button: Button
@export var escape_button: Button
#The options button of technique bar
@export var option_1: Button
@export var option_2: Button
@export var option_3: Button
@export var option_4: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_hp = Global.player_hp #connect the autoload data to battle
	max_hp = Global.max_player_hp
	weapon_atk = Global.weapon_atk
	enemy_hp = Global.enemy_hp
	max_enemy_hp = Global.max_enemy_hp
	enemy_atk = Global.enemy_atk
	enemy_def = Global.enemy_def
	xp_earn = Global.xp_earn
	player_bar.max_value = max_hp
	player_bar.value = player_hp
	enemy_bar.max_value = max_enemy_hp
	enemy_bar.value = enemy_hp
	hp_ui.text = "HP:" + str(player_hp)
	option_1.hide()
	option_2.hide()
	option_3.hide()
	option_4.hide()
	
func _attack_choose() -> void:
	if player_turn == true and enemy_turn == false:
		if enemy_hp >= 1: #wait for more steps!!
			total_damage_atk = max(0, weapon_atk - enemy_def)
			enemy_hp = max(0, enemy_hp - total_damage_atk)
			enemy_bar.value = enemy_hp
			player_turn = false
			enemy_turn = true
			turn_label.text = "Enemy's Turn"
			enemy_ui.text = "Enemy HP:" + str(enemy_hp)
			change_turn.start()
		if enemy_hp == 0:
			xp_earn += 10
			battle_end() 

#Enemy turn's settings
func _enemy_turn() -> void:
	if enemy_turn == true and player_turn == false:
		_enemy_attack()
 
func _enemy_attack() -> void:
	if player_hp >= 1:
		total_enemy_atk = max(0, enemy_atk - armor_def)
		player_hp = max(0, player_hp - total_enemy_atk)
		player_bar.value = player_hp
		player_turn = true
		enemy_turn = false
		turn_label.text = "Your Turn"
		hp_ui.text = "HP:" + str(player_hp)
	if player_hp <= 0:
		battle_end()

func battle_end() -> void:
	Global.battle_hp_update(total_damage_atk)
	Global.battle_xp_update(xp_earn)
	get_tree().call_deferred("change_scene_to_file", "res://scenes/overworld.tscn")


func _on_tech_pressed() -> void:
	attack_button.hide()
	technique_button.hide()
	item_button.hide()
	escape_button.hide()
	option_1.show() 
	option_2.show()
	option_3.show()
	option_4.show()
	
