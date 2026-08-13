extends Resource
class_name item_resource

@export var item_name: String
@export var description: String
@export var max_stack_size:int = 1
@export var item_icon: Texture2D

@export var use_in_battle := true
@export var use_in_world := true

@export var effect_type: EffectType
enum EffectType{
	NONE,
	HEAL,
	REGEN,
	DAMAGE,
	SHIELD,
	ATK_BUFF,
	DEF_BUFF,
	SPEED_BUFF,
	TELEPORT
}

@export var heal_amount:int = 0
@export var tp_amount:int = 0
@export var damage:int = 0
@export var defend_amount:int = 0
@export var duration:int= 0
