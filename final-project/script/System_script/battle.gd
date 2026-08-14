extends Node2D
#THE SCRIPT OF PLAYER ENTER BATTLE

var player_turn:bool = true
var enemy_turn:bool = false
var update_stats:bool = false
#Player variables
var player_hp:int = 1
var max_hp:int = 1
var player_tp:int = 1
var max_tp:int = 1
var player_atk:int = 1
var xp_earn:int = 1
var xp_level:int = 1
#Enemy variables
var enemy_hp: int = 5
var max_enemy_hp:int = 5
var enemy_atk:int = 1
#Other options button variables
var equipped_tech:Array[tech_resource] = [
	null,
	null,
	null,
	null
]
var replacing_tech: bool = false
var item_choosing:bool = false
var item_buttons: Array[Button] = []
var shield_amount = 0

#Damage calculate variables
var total_damage_atk:int = 0
var total_enemy_atk:int = 0 

@export var turn_label: Label
@export var hp_ui: Label
@export var enemy_ui: Label
@export var change_turn: Timer
@export var player_bar: ProgressBar
@export var enemy_bar: ProgressBar
@export var options_button: Control
@export var tech_options: Control
@export var tech_resource: Resource
@export var enemy_resource: Resource
@export var item_resource: Resource
@export var tech_1: Button
@export var tech_2: Button
@export var tech_3: Button
@export var tech_4: Button
@export var item_options: Control
@export var item_1: Button
@export var item_2: Button
@export var item_3: Button
@export var item_4: Button
@export var item_5: Button
@export var item_6: Button
@export var item_7: Button
@export var Battle_end: Control
@export var learn_tech_yes: Button
@export var learn_tech_no: Button
@export var learn_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect the autoload data to battle
	player_hp = Global.player_hp 
	max_hp = Global.max_player_hp
	player_tp = Global.player_tp
	max_tp = Global.player_tp
	player_atk = Global.player_atk
	enemy_hp = Global.enemy_hp
	max_enemy_hp = Global.max_enemy_hp
	enemy_atk = Global.enemy_atk
	xp_earn = Global.xp_earn
	xp_level = Global.xp_level
	equipped_tech = Global.equipped_tech
	if Global.battle_entered_by == "player":
		player_turn = true
		enemy_turn = false
	elif Global.battle_entered_by == "enemy":
		player_turn = false
		enemy_turn = true
	item_buttons = [
		item_1,
		item_2,
		item_3,
		item_4,
		item_5,
		item_6,
		item_7
	]
	options_button.show()
	tech_options.hide()
	item_options.hide()
	Battle_end.hide()
	learn_label.hide()
	learn_tech_yes.hide()
	learn_tech_no.hide()

func _process(delta: float) -> void:
	player_bar.value = player_hp
	player_bar.max_value = max_hp
	enemy_bar.max_value = max_enemy_hp
	enemy_bar.value = enemy_hp
	hp_ui.text = "HP:" + str(player_hp)
	if Input.is_action_just_pressed("ui_cancel") and replacing_tech == false:
		options_button.show()
		tech_options.hide()
	if Input.is_action_just_pressed("ui_cancel") and item_choosing == true:
		options_button.show()
		item_options.hide()
		item_choosing = false
		
#Changing turn by player to enemy
func player_turn_change() -> void:
	player_turn = false
	enemy_turn = true
	turn_label.text = "Enemy's Turn"
	enemy_ui.text = "Enemy HP:" + str(enemy_hp)
	enemy_bar.value = enemy_hp
	change_turn.start()

func enemy_turn_change() -> void:
	player_turn = true
	enemy_turn = false
	turn_label.text = "Your Turn"
	hp_ui.text = "HP:" + str(player_hp)
	change_turn.start()
	
#Player's basic attack-----------------------------------------------
func _attack_choose() -> void:
	if player_turn == true and enemy_turn == false:
		if enemy_hp >= 1: 
			total_damage_atk = max(0, player_atk)
			enemy_hp = max(0, enemy_hp - total_damage_atk)
			player_turn_change()
		if enemy_hp == 0:
			xp_earn = enemy_resource.xp_give
			battle_end() 

#Enemy turn's settings
func _enemy_turn() -> void:
	if enemy_turn == true and player_turn == false:
		_enemy_attack()
 
func _enemy_attack() -> void:
	if player_hp >= 1:
		total_enemy_atk = max(0, enemy_atk - shield_amount)
		player_hp = max(0, player_hp - total_enemy_atk)
		enemy_turn_change()
	if player_hp <= 0:
		battle_end()

#Player's technique attack settings----------------------------------
func _on_tech_pressed() -> void:
	options_button.hide()
	tech_options.show()	
	var tech_buttons: Array = [tech_1, tech_2, tech_3, tech_4]
	for tech in range(4):
		if tech < Global.equipped_tech.size() and Global.equipped_tech[tech] != null:
			var current_tech = Global.equipped_tech[tech]
			tech_buttons[tech].text = current_tech.tech_name
			tech_buttons[tech].disabled = false
		else:
			tech_buttons[tech].text = "Blank"
			tech_buttons[tech].disabled = true

func tech_damage_check(tech: tech_resource) -> void:
	var tech_damage = tech_resource.tech_atk
	var ability_type = tech_resource.ability
	if enemy_resource.weak == ability_type:
		tech_damage *= 2 #Hit the weakness get critical
	elif enemy_resource.resist == ability_type:
		tech_damage /= 2 #Hit the resist get half damage
	total_damage_atk = tech_damage
	enemy_hp = max(0,enemy_hp - total_damage_atk)
	enemy_bar.value = enemy_hp
	player_turn_change()
	player_tp = player_tp - tech_resource.tech_tp
	print(player_tp , "TP")
	
func _tech_options(tech: String) -> void:
	if player_turn == true and enemy_turn == false:
		var current_tech = Global.equipped_tech
		tech_resource = Global.techs[tech]
		tech_damage_check(tech_resource)
		tech_options.hide()
		options_button.show()
	if enemy_hp == 0:
			xp_earn = enemy_resource.xp_give
			print(player_hp)
			battle_end()

func _on_option_1_pressed() -> void:
	select_tech(0)
func _on_option_2_pressed() -> void:
	select_tech(1)
func _on_option_3_pressed() -> void:
	select_tech(2)
func _on_option_4_pressed() -> void:
	select_tech(3)

func select_tech(index:int)->void:
	if replacing_tech:
		Global.replace_player_tech(index, Global.new_tech)
		Global.new_tech = null
		replacing_tech = false
		tech_options.hide()
		finish_battle()
		return
	_tech_options(Global.equipped_tech[index].tech_name)

#Player's using item settings----------------------------------------	
func _item_options():
	options_button.hide()
	item_options.show()
	item_choosing = true
	print(item_buttons)
	print("item maximum stack = ", item_buttons.size())
	update_item_buttons()
	
func update_item_buttons():
	for i in range(item_buttons.size()):
		var slot = Global.inventory.item_slots[i]
		if slot.item == null:
			item_buttons[i].disabled = true
			item_buttons[i].text = "Empty"
		
			print(i, "Empty")
		else:
			print(i, slot.item.item_name)
			item_buttons[i].disabled = false
			item_buttons[i].text = slot.item.item_name 
func select_item(index:int):
	var slot = Global.inventory.item_slots[index]
	if slot.item == null:
		return
	ItemManager.use_item(slot.item,self)
	Global.inventory.remove_item(slot.item)
	player_turn_change()

func _on_item_1_pressed():
	select_item(0)
func _on_item_2_pressed():
	select_item(1)
func _on_item_3_pressed():
	select_item(2)
func _on_item_4_pressed():
	select_item(3)
func _on_item_5_pressed():
	select_item(4)
func _on_item_6_pressed():
	select_item(5)
func _on_item_7_pressed():
	select_item(6)
	



#Player's leaving battle settings------------------------------------
func battle_end() -> void:
	Global.battle_hp_update(player_hp)
	Global.battle_tp_update(player_tp)
	Global.battle_xp_update(xp_earn)
	if Global.new_tech != null:
		print("Show UI")
		show_learn_ui()
	elif Global.new_tech == null:
		print("Finish Battle")
		finish_battle()

func _escape() -> void:
	if player_turn == true and enemy_turn == false:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/map_scene/overworld.tscn")
	
func replace_tech() -> void:
	Battle_end.hide()
	replacing_tech = true
	options_button.hide()
	tech_options.show()
	var tech_buttons = [tech_1, tech_2, tech_3, tech_4]
	for i in range(4):
		tech_buttons[i].text = Global.equipped_tech[i].tech_name

func not_replace_tech() -> void:
	Global.new_tech = null
	replacing_tech = false
	Battle_end.hide()
	learn_label.hide()
	learn_tech_yes.hide()
	learn_tech_no.hide()

	finish_battle()

func show_learn_ui():
	player_turn = false
	enemy_turn = false
	change_turn.stop()
	options_button.hide()
	tech_options.hide()
	Battle_end.show()
	learn_label.show()
	learn_tech_yes.show()
	learn_tech_no.show()
	learn_label.text = "Learn " + Global.new_tech.tech_name + " ?"

func finish_battle():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/map_scene/overworld.tscn")	
