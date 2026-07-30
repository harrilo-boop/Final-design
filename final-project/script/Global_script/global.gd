extends Node
#All Variables for player in game


@export var weapon_resource: Resource
@export var armor_resource: Resource
@export var tech_resource: Resource
@export var item_resource: Resource

#Player's health
var player_hp:int = 20
var max_player_hp:int = 20

#Player's stats
var player_tp:int = 20
var max_tp:int = 20
var weapon_atk:int = 1
var armor_def:int = 1

#Player's current stats
const MAX_TECH = 4
var new_tech: tech_resource = null
var equipped_tech:Array[tech_resource] = [
	null,
	null,
	null,
	null
]
var equipped_weapon = null
var equipped_armor = null
var tech_replace:bool = false

#Player's experience system
var player_xp:int = 0
var xp_earn: int = 0
var xp_level:int = 1
var xp_needed:int = 0
var max_level:int = 100

#For locating player's last position before entering the battle
var last_position: Vector2 = Vector2.ZERO
var last_scene:String = "overworld"
var battle_entered_by:String = "player"

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
	"Fire ball": load("res://resources/Tech/Fire_tech2.tres"),
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
	"Flame bottle": load("res://resources/Item/Attack_item/FlameBottle.tres"),
	"TemporarySheild": load("res://resources/Item/Defend_item/TemporarySheild.tres"),
	"Heal Potion": load("res://resources/Item/Heal_item/HealPotion.tres"),
	"Continous Heal Potion": load("res://resources/Item/Heal_item/ContinousHealPotion.tres")
}

#Current technique using as start condition
func _ready() -> void:
	equipped_tech[0] = techs["Flame"]
	equipped_tech[1] = techs["Water ball"]
	equipped_tech[2] = null
	equipped_tech[3] = null
	equipped_weapon = weapons["Starter sword"]
	equipped_armor = armors["Starter armor"]
	xp_needed = level_up(xp_level)

func player_stats() -> void:
	#Current weapon using
	weapon_atk = equipped_weapon.weapon_atk
	#Current armor using
	armor_def = equipped_armor.armor_def

#Updating player's health after battle
func battle_hp_update(current_hp: int):
	player_hp = current_hp

#Updating player's tech after battle
func battle_tp_update(current_tp: int) -> void:
	player_tp = current_tp

func replace_player_tech(index: int, tech: tech_resource) -> void:
	equipped_tech[index] = tech
	
#Updating player's xp after battle
func battle_xp_update(xp_earn: int) -> bool:
	player_xp += xp_earn
	check_levelup()
	return new_tech != null
	
#Setting the xp requirement for every level
func level_up(xp_level: int) -> int:
	var basic_xp:int = 10
	var xp_power:float = 1.5 
	return int(basic_xp * pow(xp_level, xp_power))

#Checkinng whever can player level up
func check_levelup():
	while player_xp >= xp_needed and xp_level < max_level:
		player_xp -= xp_needed
		xp_level += 1
		xp_needed = level_up(xp_level)
		check_new_tech()
	print("Lv.", xp_level, "| " , player_xp, "/" , xp_needed, "Current experience to next level")
	
func check_new_tech() -> void:
	for tech in techs.values():
		if tech.required_level == xp_level:
			learn_new_skill(tech)

func learn_new_skill(new_tech: tech_resource) -> void:
	if equipped_tech.has(new_tech):
		return
	for i in range(MAX_TECH):
		if equipped_tech[i] == null:
			replace_player_tech(i, new_tech)
			print("Learned ", new_tech.tech_name)
			return
	self.new_tech = new_tech
	
