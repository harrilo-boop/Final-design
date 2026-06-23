extends Node
#All Variables for player in game

@export var weapon_stats: Resource
@export var armor_stats: Resource
@export var tech_resource: Resource

#Player's health
var player_hp:int = 10
var max_player_hp:int = 10

#Player's stats
var player_tp:int = 20
var max_tp:int = 20
var weapon_atk:int = 2
var armor_def:int = 1

#Player's tech options
var equipped_tech: Array[tech_resource] = [null, null, null, null]

#Player's experience system
var player_xp:int = 0
var xp_earn: int = 0
var xp_level:int = 1
var xp_needed:int = 0
var max_level:int = 100

#For locating player's last position before entering the battle
var last_position: Vector2 = Vector2.ZERO
var previous_scene: String = ""

#Enemy's health
var enemy_hp:int = 5
var max_enemy_hp:int = 5

#Enemy's stats
var enemy_atk:int = 2
var enemy_def:int = 0

var current_level:int = 0

#Updating player's health after battle
func _ready() -> void:
	equipped_tech[0] = load("res://resources/Tech/Fire_tech1.tres")
	equipped_tech[1] = load("res://resources/Tech/Water_tech1.tres")
	equipped_tech[2] = null
	equipped_tech[3] = null

func battle_hp_update(total_enemy_attack: int) -> void:
	player_hp = player_hp - total_enemy_attack

func battle_xp_update(xp_earn: int) -> void:
	player_xp = player_xp + xp_earn
	check_levelup()

func level_up(xp_level: int) -> int:
	var basic_xp:int = 10
	return int(basic_xp * xp_level)
	
func check_levelup() -> void:
	if player_xp >= xp_needed and xp_level <= max_level:
		player_xp -= xp_needed
		xp_level += 1
		xp_needed = level_up(xp_level)
		print(xp_level , "and" , xp_needed) #For testing use

func current_stats() -> void:
	weapon_atk = weapon_stats.weapon_atk
	armor_def = armor_stats.armor_def
