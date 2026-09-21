extends Node2D
#THE SCRIPT OF PLAYER ENTER BATTLE

var player_turn:bool = true
var enemy_turn:bool = false
var battle_finished: bool = false
#Player variables
var player_hp:int = 1
var max_hp:int = 1
var player_tp:int = 1
var max_tp:int = 1
var player_atk:int = 1
var xp_earn:int = 1
var xp_level:int = 1
var shield_amount:int = 0
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

#Damage calculate variables
var total_damage_atk:int = 0
var total_enemy_atk:int = 0 

@export var turn_label: Label
@export var hp_ui: Label
@export var enemy_ui: Label
@export var change_turn: Timer
@export var player_bar: ProgressBar
@export var player_bar_ui: AnimatedSprite2D
@export var enemy_bar: ProgressBar
@export var enemy_bar_ui: AnimatedSprite2D
@export var player_animation: AnimatedSprite2D
@export var enemy_animation: AnimatedSprite2D
@export var options_button: Control
@export var tech_options: Control
@export var tech_data: Resource
@export var enemy_data: Resource
@export var item_data: Resource
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
@export var ui_display_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_button.show()
	tech_options.hide()
	item_options.hide()
	Battle_end.hide()
	learn_label.hide()
	learn_tech_yes.hide()
	learn_tech_no.hide()
	item_buttons = [
		item_1,
		item_2,
		item_3,
		item_4,
		item_5,
		item_6,
		item_7
	]
	item_choosing = false
	replacing_tech = false
	battle_finished = false
	#Player data---------------------------------
	player_hp = Global.player_hp
	max_hp = Global.max_player_hp
	player_tp = Global.player_tp
	max_tp = Global.max_tp
	player_atk = Global.player_atk
	xp_earn = Global.xp_earn
	xp_level = Global.xp_level
	equipped_tech = Global.equipped_tech
	player_animation.flip_h = true
	#Enemy data----------------------------------
	print("Current floor: ", Global.current_floor)
	print("Enemy count: ", EnemyManager.floor_enemies.size())

	enemy_data = EnemyManager.get_enemy_for_floor(Global.current_floor)

	if enemy_data == null:
		push_error("No enemy data for floor: " + str(Global.current_floor))
		return

	enemy_hp = enemy_data.enemy_hp
	max_enemy_hp = enemy_data.enemy_hp
	enemy_atk = enemy_data.enemy_atk

func _process(_delta: float) -> void:
	player_bar.value = player_hp
	player_bar.max_value = max_hp
	enemy_bar.max_value = max_enemy_hp
	enemy_bar.value = enemy_hp
	hp_ui.text = "HP:" + str(player_hp)
	if Input.is_action_just_pressed("ui_cancel"):
		if item_choosing:
			options_button.show()
			item_options.hide()
			item_choosing = false
		elif replacing_tech:
			replacing_tech = false
			tech_options.hide()
			options_button.show()
		elif tech_options.visible:
			tech_options.hide()
			options_button.show()

#Changing turn by player to enemy
func player_turn_change() -> void:
	player_turn = false
	enemy_turn = true
	turn_label.text = "Enemy's Turn"
	enemy_ui.text = "Enemy HP:" + str(enemy_hp)
	enemy_bar.value = enemy_hp
	update_player_hp_bar()
	update_enemy_hp_bar()
	print(player_tp , "TP")
	options_button.hide()
	change_turn.start()

func enemy_turn_change() -> void:
	player_turn = true
	enemy_turn = false
	turn_label.text = "Your Turn"
	hp_ui.text = "HP:" + str(player_hp)
	player_bar.value = player_hp
	update_player_hp_bar()
	update_enemy_hp_bar()
	options_button.show()
	change_turn.start()

func update_player_hp_bar() -> void:
	var hp_ratio = float(player_hp) / float(max_hp)
	if hp_ratio <= 0.0:
		player_bar_ui.play("0%")
	elif hp_ratio <= 0.2:
		player_bar_ui.play("20%")
	elif hp_ratio <= 0.4:
		player_bar_ui.play("40%")
	elif hp_ratio <= 0.6:
		player_bar_ui.play("60%")
	elif hp_ratio <= 0.8:
		player_bar_ui.play("80%")
	else:
		player_bar_ui.play("100%")

func update_enemy_hp_bar() -> void:
	var enemy_ratio = float(enemy_hp) / float(max_enemy_hp)
	if enemy_ratio <= 0.0:
		enemy_bar_ui.play("0%")
	elif enemy_ratio <= 0.2:
		enemy_bar_ui.play("20%")
	elif enemy_ratio <= 0.4:
		enemy_bar_ui.play("40%")
	elif enemy_ratio <= 0.6:
		enemy_bar_ui.play("60%")
	elif enemy_ratio <= 0.8:
		enemy_bar_ui.play("80%")
	else:
		enemy_bar_ui.play("100%")

#Player's basic attack-----------------------------------------------
func _attack_choose() -> void:
	if player_animation.animation == "default":
		player_animation.play("attack")
		enemy_animation.play("attacked")
	if player_turn == true and enemy_turn == false:
		if enemy_hp >= 1: 
			total_damage_atk = max(0, player_atk)
			enemy_hp = max(0, enemy_hp - total_damage_atk)
		if enemy_hp <= 0:
			xp_earn = enemy_data.xp_give
			battle_end() 
		else:
			player_turn_change()

#Enemy turn's settings
func _enemy_turn() -> void:
	if enemy_turn == true and player_turn == false:
		_enemy_attack()
 
func _enemy_attack() -> void:
	if player_hp >= 1:
		if enemy_animation.animation == "default":
			enemy_animation.play("attack")
		total_enemy_atk = max(0, enemy_atk - Global.shield_amount)
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


func tech_damage_check(tech_data: tech_resource) -> void:
	if player_animation.animation == "default":
		player_animation.play("attack")
		enemy_animation.play("attacked")
	var tech_damage = tech_data.tech_atk
	var ability_type = tech_data.ability
	if enemy_data.weak == ability_type:
		tech_damage *= 2 #Hit the weakness get critical
	elif enemy_data.resist == ability_type:
		tech_damage /= 2 #Hit the resist get half damage
	total_damage_atk = tech_damage
	enemy_hp = max(0,enemy_hp - total_damage_atk)
	enemy_bar.value = enemy_hp
	player_tp = player_tp - tech_data.tech_tp

func _tech_options(tech: String) -> void:
	if player_turn == true and enemy_turn == false:
		if enemy_hp >= 1:
			var _current_tech = Global.equipped_tech
			tech_data = Global.techs[tech]
			tech_damage_check(tech_data)
			tech_options.hide()
			options_button.show()
			player_turn_change()
		if enemy_hp == 0:
			xp_earn = enemy_data.xp_give
			print(player_hp)
			battle_end()
			
func _player_attack_finish() -> void:
	player_animation.play("default")
	enemy_animation.play("default")

func _enemy_attack_finish() -> void:
	enemy_animation.play("default")

func _on_option_1_pressed() -> void:
	select_tech(0)
func _on_option_2_pressed() -> void:
	select_tech(1)
func _on_option_3_pressed() -> void:
	select_tech(2)
func _on_option_4_pressed() -> void:
	select_tech(3)

func select_tech(index: int) -> void:
	if replacing_tech:
		Global.replace_player_tech(index, Global.new_tech)
		Global.new_tech = null
		replacing_tech = false
		tech_options.hide()
		show_next_pending_tech()
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
			item_buttons[i].text = str(slot.quantity)
			item_buttons[i].icon = slot.item.item_icon
func select_item(index:int):
	var slot = Global.inventory.item_slots[index]
	if slot.item == null:
		return
	ItemManager.use_item(slot.item,self)
	Global.inventory.remove_item(slot.item)
	options_button.show()
	item_options.hide()
	item_choosing = false
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
	if battle_finished:
		return
	battle_finished = true
	Global.battle_hp_update(player_hp)
	Global.battle_tp_update(player_tp)
	Global.battle_xp_update(xp_earn)
	options_button.hide()
	tech_options.hide()
	item_options.hide()
	ui_display_timer.stop()
	Battle_end.show()
	show_next_pending_tech()
	
func ui_display_end() -> void:
	finish_battle()

func show_next_pending_tech() -> void:
	Global.new_tech = Global.get_next_pending_tech()
	if Global.new_tech != null:
		show_learn_ui()
	else:
		learn_label.text = "Battle Finish"
		learn_tech_yes.hide()
		learn_tech_no.hide()
		ui_display_timer.start()

func _escape() -> void:
	if player_turn == true and enemy_turn == false:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/Map_scene/TowerRoom.tscn")


func replace_tech() -> void:
	replacing_tech = true
	tech_options.show()
	var tech_buttons = [tech_1, tech_2, tech_3, tech_4]
	for i in range(4):
		if Global.equipped_tech[i] != null:
			tech_buttons[i].text = Global.equipped_tech[i].tech_name
		else:
			tech_buttons[i].text = "Blank"

func not_replace_tech() -> void:
	Global.new_tech = null
	replacing_tech = false
	learn_label.hide()
	learn_tech_yes.hide()
	learn_tech_no.hide()
	tech_options.hide()
	show_next_pending_tech()

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
	Global.floor_require = true
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Map_scene/TowerRoom.tscn")
