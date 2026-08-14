extends Node
#All Variables for player in game

@export var tech_resource: Resource
@export var item_resource: Resource

#Player's health
var player_hp:int = 20
var max_player_hp:int = 20

#Player's stats
var player_tp:int = 20
var max_tp:int = 20
var player_atk:int = 2

#Player's current stats
const MAX_TECH = 4
var new_tech: tech_resource = null
var equipped_tech:Array[tech_resource] = [
	null,
	null,
	null,
	null
]

var tech_replace:bool = false
var inventory: Inventory

#Player's experience system
var player_xp:int = 0
var xp_earn: int = 0
var xp_level:int = 1
var xp_needed:int = 0
var max_level:int = 50

#For locating player's last position before entering the battle
var last_position: Vector2 = Vector2.ZERO
var last_scene:String = "overworld"
var battle_entered_by:String = "player"

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
	"Earthquake": load("res://resources/Tech/Ground/Ground_tech5.tres"),
	"Nature Power": load("res://resources/Tech/Ground/Ground_tech4.tres"),
	"World Collapse": load("res://resources/Tech/Ground/Ground_tech5.tres"),
	#Ability(Water)--------------------------------------------------------------------------------
	"Water Ball": load("res://resources/Tech/Water/Water_tech1.tres"),
	"Thunder Shock": load("res://resources/Tech/Water/Water_tech4.tres"),
	"Tsunami": load("res://resources/Tech/Water/Water_tech5.tres"),
	#Ability(Wind)---------------------------------------------------------------------------------
	"Wind Blow": load("res://resources/Tech/Wind/Wind_tech1.tres"),
	"Hurricane": load("res://resources/Tech/Wind/Wind_tech3.tres"),
	"Echoes": load("res://resources/Tech/Wind/Wind_tech4.tres"),
	"Triple Typhoon": load("res://resources/Tech/Wind/Wind_tech5.tres")
}
var items = {
	#Attackable_item-------------------------------------------------------------------------------
	"Flame Bottle": load("res://resources/Item/Attack_item/FlameBottle.tres"),
	#Buff_player_item------------------------------------------------------------------------------
	"Attack Up Potion": load("res://resources/Item/Buff_item/AttackUpPotion.tres"),
	#Defendable_item-------------------------------------------------------------------------------
	"TemporarySheild": load("res://resources/Item/Defend_item/TemporarySheild.tres"),
	"Wood Sheild": load("res://resources/Item/Defend_item/WoodSheild.tres"),
	#Heal_player_item------------------------------------------------------------------------------
	"Heal Potion": load("res://resources/Item/Heal_item/HealPotion.tres"),
	"Strong Heal Potion": load("res://resources/Item/Heal_item/StrongHealPotion.tres"),
	"Rare Heal Potion": load("res://resources/Item/Heal_item/RareHealPotion.tres"),
	"Super Rare Heal Potion": load("res://resources/Item/Heal_item/SuperRareHealPotion.tres"),
	"Technique Point Potion": load("res://resources/Item/Heal_item/TechniquePointPotion.tres"),
	"Strong Technique Potion": load("res://resources/Item/Heal_item/StrongTechniquePointPotion.tres")
}

#Current technique using as start condition
func _ready() -> void:
	equipped_tech[0] = techs["Flame"]
	equipped_tech[1] = techs["Water Ball"]
	equipped_tech[2] = null
	equipped_tech[3] = null
	xp_needed = level_up(xp_level)
	inventory = Inventory.new()
	add_child(inventory)
	

#Updating player's health after battle
func battle_hp_update(current_hp: int):
	player_hp = current_hp

#Updating player's tech after battle
func battle_tp_update(current_tp: int):
	player_tp = current_tp
	
func hp_max_increase(levelup_hp: int) -> int:
	levelup_hp = max_player_hp
	var hp_power:float = 1.3
	return int(levelup_hp * pow(xp_level, hp_power))

func tp_max_increase(levelup_tp: int) -> int:
	levelup_tp = max_tp
	var tp_power:float = 1.1
	return int(levelup_tp * pow(xp_level, tp_power))

func atk_max_increase(current_atk:int) -> int:
	current_atk = player_atk
	var atk_power:float = 1.2
	return int(current_atk * pow(xp_level, atk_power))

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
		max_player_hp = hp_max_increase(max_player_hp)
		max_tp = tp_max_increase(max_tp)
		player_atk = atk_max_increase(player_atk)
		check_new_tech()
	print("Lv.", xp_level, "| " , player_xp, "/" , xp_needed, "Current experience to next level")
	print("Current HP = ", player_hp, "/", max_player_hp)
	print("Current TP = ", player_tp, "/", max_tp)
	print("Current Attack = ", player_atk)

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
	
