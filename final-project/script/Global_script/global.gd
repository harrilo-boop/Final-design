extends Node
#All Variables for player in game

#Player's health
var player_hp:int = 100
var max_player_hp:int = 100

#Player's stats
var player_atk:int = 2
var shield_amount = 0

#Player's current stats
const MAX_TECH = 4
var new_tech: tech_resource = null
var equipped_tech:Array[tech_resource] = [
	null,
	null,
	null,
	null
]
var pending_techs: Array[tech_resource] = []
var tech_replace:bool = false
var inventory: Inventory

#Player's experience system
var player_xp:int = 0
var xp_earn: int = 0
var xp_level:int = 1
var xp_needed:int = 0
var max_level:int = 50
var current_floor:int = 0

#For locating player's last position before entering the battle
var last_position: Vector2 = Vector2.ZERO
var last_scene:String = "overworld"
var floor_require: bool = false

#Enemy's stats
var enemy_hp:int = 10
var max_enemy_hp:int = 10
var enemy_atk:int = 2

#Dictionary for all techniques
var techs = {
	#Ability(Fire)----------------------------------------------------------------------------------
	"Flame" : load("res://resources/Tech/Fire/Fire_tech1.tres"),
	"Fire Ball": load("res://resources/Tech/Fire/Fire_tech2.tres"),
	"Heat Wave": load("res://resources/Tech/Fire/Fire_tech3.tres"),
	"Blizzard": load("res://resources/Tech/Fire/Fire_tech4.tres"),
	"Volcano Explosion": load("res://resources/Tech/Fire/Fire_tech5.tres"),
	#Ability(Ground)-------------------------------------------------------------------------------
	"Mud": load("res://resources/Tech/Ground/Ground_tech1.tres"),
	"Spikes": load("res://resources/Tech/Ground/Ground_tech2.tres"),
	"Earthquake": load("res://resources/Tech/Ground/Ground_tech3.tres"),
	"Nature Power": load("res://resources/Tech/Ground/Ground_tech4.tres"),
	"World Collapse": load("res://resources/Tech/Ground/Ground_tech5.tres"),
	#Ability(Water)--------------------------------------------------------------------------------
	"Water Ball": load("res://resources/Tech/Water/Water_tech1.tres"),
	"Waves": load("res://resources/Tech/Water/Water_tech2.tres"),
	"Hydro Stream": load("res://resources/Tech/Water/Water_tech3.tres"),
	"Thunder Shock": load("res://resources/Tech/Water/Water_tech4.tres"),
	"Tsunami": load("res://resources/Tech/Water/Water_tech5.tres"),
	#Ability(Wind)---------------------------------------------------------------------------------
	"Wind Blow": load("res://resources/Tech/Wind/Wind_tech1.tres"),
	"Whirlwind": load("res://resources/Tech/Wind/Wind_tech2.tres"),
	"Hurricane": load("res://resources/Tech/Wind/Wind_tech3.tres"),
	"Echoes": load("res://resources/Tech/Wind/Wind_tech4.tres"),
	"Triple Typhoon": load("res://resources/Tech/Wind/Wind_tech5.tres")
}

var items = {
	#Buff_player_item------------------------------------------------------------------------------
	"Attack Up Potion": load("res://resources/Item/Buff_item/AttackUpPotion.tres"),
	#Defendable_item-------------------------------------------------------------------------------
	"Temporary Sheild": load("res://resources/Item/Defend_item/TemporarySheild.tres"),
	"Wood Sheild": load("res://resources/Item/Defend_item/WoodSheild.tres"),
	#Heal_player_item------------------------------------------------------------------------------
	"Heal Potion": load("res://resources/Item/Heal_item/HealPotion.tres"),
	"Strong Heal Potion": load("res://resources/Item/Heal_item/StrongHealPotion.tres"),
	"Rare Heal Potion": load("res://resources/Item/Heal_item/RareHealPotion.tres"),
	"Super Rare Heal Potion": load("res://resources/Item/Heal_item/SuperRareHealPotion.tres")
}

var enemies = {
	"Enemy_01": preload("res://resources/Enemy/Enemy_01.tres"),
	"Enemy_02": preload("res://resources/Enemy/Enemy_02.tres"),
	"Enemy_03": preload("res://resources/Enemy/Enemy_03.tres"),
	"Enemy_04": preload("res://resources/Enemy/Enemy_04.tres"),
	
	"Enemy_05": preload("res://resources/Enemy/Enemy_05.tres"),
	"Enemy_06": preload("res://resources/Enemy/Enemy_06.tres"),
	"Enemy_07": preload("res://resources/Enemy/Enemy_07.tres"),
	"Enemy_08": preload("res://resources/Enemy/Enemy_08.tres"),
	
	"Enemy_09": preload("res://resources/Enemy/Enemy_09.tres"),
	"Enemy_10": preload("res://resources/Enemy/Enemy_10.tres"),
	"Enemy_11": preload("res://resources/Enemy/Enemy_11.tres"),
	"Enemy_12": preload("res://resources/Enemy/Enemy_12.tres"),
	
	"Boss_01": preload("res://resources/Enemy/Enemy_Boss1.tres"),
	"Boss_02": preload("res://resources/Enemy/Enemy_Boss2.tres"),
	"Boss_03": preload("res://resources/Enemy/Enemy_Boss3.tres"),
	"Boss_04": preload("res://resources/Enemy/Enemy_Boss4.tres"),
	"Boss_05": preload("res://resources/Enemy/Enemy_Boss5.tres")
}

#Current technique using as start condition
func _ready() -> void:
	equipped_tech[0] = techs["Flame"]
	equipped_tech[1] = techs["Water Ball"]
	equipped_tech[2] = null
	equipped_tech[3] = null
	xp_needed = level_up()
	inventory = Inventory.new()
	add_child(inventory)
	

#Updating player's health after battle
func battle_hp_update(current_hp: int):
	player_hp = current_hp

func hp_max_increase(levelup_hp: int) -> int:
	levelup_hp = max_player_hp
	var hp_power:float = 1.1
	return int(levelup_hp * hp_power)

func replace_player_tech(index: int, tech: tech_resource) -> void:
	equipped_tech[index] = tech
	
#Updating player's xp after battle
func battle_xp_update(xp_gain: int) -> bool:
	player_xp += xp_gain
	check_levelup()
	return new_tech != null
	
#Setting the xp requirement for every level
func level_up() -> int:
	var basic_xp:int = 10
	var xp_power:float = 1.2
	return int(basic_xp * pow(xp_level, xp_power))

#Checkinng whever can player level up
func check_levelup():
	while player_xp >= xp_needed and xp_level < max_level:
		player_xp -= xp_needed
		xp_level += 1
		xp_needed = level_up()
		max_player_hp = hp_max_increase(max_player_hp)
		check_new_tech()
	print("Lv.", xp_level, "| " , player_xp, "/" , xp_needed, "Current experience to next level")
	print("Current HP = ", player_hp, "/", max_player_hp)

func check_new_tech() -> void:
	for tech in techs.values():
		if tech.required_level == xp_level:
			if equipped_tech.has(tech):
				continue
			learn_new_skill(tech)

func learn_new_skill(new_tech: tech_resource) -> void:
	if equipped_tech.has(new_tech):
		return
	for i in range(MAX_TECH):
		if equipped_tech[i] == null:
			replace_player_tech(i, new_tech)
			print("Learned ", new_tech.tech_name)
			return
	if not pending_techs.has(new_tech):
		pending_techs.append(new_tech)

func get_next_pending_tech() -> tech_resource:
	if pending_techs.is_empty():
		return null
	return pending_techs.pop_front()
