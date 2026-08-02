extends Node

@export var player: CharacterBody2D
@export var speed_timer: Timer

func use_item(item:item_resource, battle):
	match item.effect_type:
		item_resource.EffectType.HEAL:
			use_heal(item, battle)
		item_resource.EffectType.REGEN:
			use_regen(item, battle)
		item_resource.EffectType.SHIELD:
			use_shield(item, battle)
		item_resource.EffectType.DAMAGE:
			use_damage(item,battle)

func use_heal(item,battle):
	battle.player_hp += item.heal_amount
	battle.player_hp = min(battle.player_hp,battle.max_hp)

func use_regen(item,battle):
	battle.regen_amount = item.heal_amount
	battle.regen_turn = item.duration

func use_shield(item,battle):
	battle.shield_amount = item.defend_amount
	battle.shield_turn = item.duration

func use_damage(item,battle):
	battle.enemy_hp -= item.damage
	if battle.enemy_hp < 0:
		battle.enemy_hp = 0
