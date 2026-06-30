extends Node
#All Variables for player in game


@export var weapon_resource: Resource
@export var armor_resource: Resource
@export var tech_resource: Resource

#Player's health
var player_hp:int = 20
var max_player_hp:int = 10

#Player's stats
var player_tp:int = 20
var max_tp:int = 20
var weapon_atk:int = 1
var armor_def:int = 1

#Player's current stats
var equipped_tech: Array[tech_resource] = [null, null, null, null]
var equipped_weapon = null
var equipped_armor = null

#Player's experience system
var player_xp:int = 0
var xp_earn: int = 0
var xp_level:int = 1
var xp_needed:int = 0
var max_level:int = 100

#For locating player's last position before entering the battle
var last_position: Vector2 = Vector2.ZERO

#Enemy's stats
var enemy_hp:int = 10
var max_enemy_hp:int = 10
var enemy_atk:int = 2

var current_level:int = 0

#Dictionary for all techniques
var weapons = {
	"Starter sword": load("res://resources/Weapon/Weapon_base1.tres"),
	"Wood sword": load("res://resources/Weapon/Weapon_base2.tres")
}

var armors = {
	"Starter armor": load("res://resources/Armor/Armor_base1.tres"),
	"Wood armor": load("res://resources/Armor/Armor_base2.tres")
}
var techs = {
	#Ability-----Fire
	"Flame" : load("res://resources/Tech/Fire_tech1.tres"),
	#Ability-----Water
	"Water ball": load("res://resources/Tech/Water_tech1.tres"),
	#Ability-----Electric
	#Ability-----Wind
	"Wind blow": load("res://resources/Tech/Wind_tech1.tres"),
	#Ability-----Support
	#Ability-----Heal 
	"Heal (Low)": load("res://resources/Tech/Heal_tech1.tres")
}


var items = {
	"Heal Potion": load("res://resources/Item/Heal_base1.tres"),
	"Temporary sheild": load("res://resources/Item/Defend_base1.tres")
}

#Current technique using as start condition
func _ready() -> void:
	equipped_tech[0] = load("res://resources/Tech/Fire_tech1.tres")
	equipped_tech[1] = load("res://resources/Tech/Water_tech1.tres")
	equipped_tech[2] = null
	equipped_tech[3] = null
	equipped_weapon = load("res://resources/Weapon/Weapon_base1.tres")
	equipped_armor = load("res://resources/Armor/Armor_base1.tres")

func player_stats() -> void:
	#Current weapon using
	weapon_atk = equipped_weapon.weapon_atk
	#Current armor using
	armor_def = equipped_armor.armor_def


#Updating player's health after battle
func battle_hp_update(total_enemy_attack: int) -> void: 
	player_hp = player_hp - total_enemy_attack
	
#Updating player's xp after battle
func battle_xp_update(xp_earn: int) -> void:
	player_xp = player_xp + xp_earn
	check_levelup()
	
#Setting the xp requirement for every level
func level_up(xp_level: int) -> int:
	var basic_xp:int = 10
	var xp_power:float = 1.5 
	return int(basic_xp * pow(xp_level, xp_power))

#Checkinng whever can player level up
func check_levelup() -> void:
	if player_xp >= xp_needed and xp_level <= max_level:
		player_xp = player_xp - xp_needed
		xp_level += 1
		xp_needed = level_up(xp_level)
	print("Lv.", xp_level , "| " , player_xp, "/" , xp_needed, "Current Experience") #For testing use
