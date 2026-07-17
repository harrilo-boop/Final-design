extends Resource

class_name item_resource

@export_group("Main_item")
@export var item_icon: Texture2D
@export var item_name: String

@export_group("Classification")
enum item_type{none, attack, defend, heal, other}
@export var type: item_type = item_type.none

@export_group("Heal")
@export var heal_amount:int = 0

@export_group("attack")
@export var attack_amount:int = 0
enum Ability{None, Fire, Water, Electric, Wind}
@export var ability_type: Ability = Ability.None

@export_group("defend")
@export var defend_amount:int = 0
@export var duration_round:int = 0
