extends Node

@export var player: CharacterBody2D
@export var speed_timer: Timer

func use_item(item:item_resource, battle):
	match item.effect_type:
		item_resource.EffectType.HEAL:
			use_heal(item, battle)
		item_resource.EffectType.SHIELD:
			use_shield(item, battle)
		item_resource.EffectType.DAMAGE:
			use_damage(item,battle)
		item_resource.EffectType.ATK_BUFF or item_resource.EffectType.TECH_BUFF:
			use_buff(item,battle)

func use_heal(item,battle):
	battle.player_hp += item.heal_amount
	battle.player_hp = min(battle.player_hp,battle.max_hp)
	battle.player_tp = item.tp_amount
	battle.player_tp = min(battle.player_tp, battle.max_tp)
	
func use_shield(item,battle):
	battle.shield_amount = item.defend_amount

func use_damage(item,battle):
	battle.enemy_hp -= item.damage
	if battle.enemy_hp < 0:
		battle.enemy_hp = 0

func use_buff(item,battle):
	battle.player_atk * item.atk_up
	battle.total_damage_attack * item.tech_up
