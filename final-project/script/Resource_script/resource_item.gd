extends Resource
class_name item_resource

@export var item_name: String
@export var description: String
@export var max_stack_size:int = 1
@export var item_icon: Texture2D


@export var effect_type: EffectType
enum EffectType{
	NONE,
	HEAL,
	SHIELD,
	ATK_BUFF,
	TECH_BUFF,
}

@export var heal_amount:int = 0
@export var tp_amount:int = 0
@export var damage:int = 0
@export var defend_amount:int = 0
@export var atk_up: int = 0
@export var tech_up:int = 0
