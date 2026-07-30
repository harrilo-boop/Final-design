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

@export var heal_amount := 0
@export var damage := 0
@export var ability := abilities.None
enum abilities{None, Fire, Water, Electric, Wind}

@export var defend_amount := 0
@export var duration := 0
@export var target_scene := ""
@export var target_position := Vector2.ZERO
