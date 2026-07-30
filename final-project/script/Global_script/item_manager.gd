extends Node

var player_hp:int = 1
var player_regen:int = 1
var player_regen_turn:int = 1

@export var item: item_resource
@export var player: CharacterBody2D
@export var speed_timer: Timer

func _ready() -> void:
	player_hp = Global.player_hp

func use_item():
	match item.effect_type:

		item.EffectType.HEAL:
			use_heal(item)

		item.EffectType.REGEN:
			use_regen(item)

		item.EffectType.DAMAGE:
			use_damage(item)

		item.EffectType.SHIELD:
			use_shield(item)


func use_heal(item):
	player_hp += item.heal_amount

func use_regen(item):
	player_regen = item.heal_amount
	player_regen_turn = item.duration

func use_damage(item):
	pass
	

func use_shield(item):
	pass
