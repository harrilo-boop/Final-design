extends CharacterBody2D

class_name Player
#THE PLAYER SCRIPT WITH OVERWORLD SETTINGS

var speed:float = 500
var is_attacking: bool = false
var can_attack: bool = true
var open_itembox: bool = false
var return_from_battle:bool = true
var last_direction: Vector2 = Vector2.RIGHT
var hitbox_offset: Vector2
var last_position: Vector2 = Vector2(0,0)
var battle_entered_by:String = ""

@export var player: CharacterBody2D
@export var pivot: Marker2D
@export var sword_area: Area2D
@export var sword_collision: CollisionShape2D
@export var timer: Timer

func _ready() -> void:
	sword_area.monitoring = false
	sword_collision.disabled = true
	hitbox_offset = sword_area.position
	if Global.last_position != Vector2.ZERO:
		global_position = Global.last_position
		Global.last_position = Vector2.ZERO
	Global.last_position = Vector2.ZERO
	
func _process(delta: float) -> void:
	move_player()
	handle_attack()
	if Input.is_action_just_pressed("ui_pause"):
		Global.last_position = global_position
		get_tree().call_deferred("change_scene_to_file", "res://scenes/UI_scene/Pause_menu.tscn")
	if Input.is_action_just_pressed("ui_run"):
		speed = speed * 1.2
	elif Input.is_action_just_released("ui_run"):
		speed = speed / 1.2

func _on_spawn(position: Vector2, direction: String) -> void:
	global_position = position
	
func move_player() -> void:
	var direction: Vector2 = Vector2(0.0, 0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		velocity = speed * direction.normalized()
		last_direction = direction
		update_hitbox_offset()
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func update_hitbox_offset() -> void:
	var dir = last_direction.normalized()
	var distance = 80   
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			sword_area.position = Vector2(distance, 0)     
		else:
			sword_area.position = Vector2(-distance, 0)    
	else:
		if dir.y > 0:
			sword_area.position = Vector2(0, distance)     
		else:
			sword_area.position = Vector2(0, -distance)  

func handle_attack() -> void:
	if Input.is_action_just_pressed("ui_attack"):
		_start_attack()

func _start_attack() -> void:
	is_attacking = true
	sword_area.monitoring = true
	sword_collision.disabled = false
	timer.start()

func end_attack() -> void:
	sword_area.monitoring = false
	sword_collision.disabled = true
	
	is_attacking = false

func _on_sword_hit(body: Node) -> void:
	if body == self:
		return
	if body.is_in_group("Enemy"):
		_enter_battle()

func _enter_battle() -> void: 
	Global.last_position = global_position
	battle_entered_by = "player"
	Global.battle_entered_by = battle_entered_by
	get_tree().call_deferred("change_scene_to_file", "res://scenes/UI_scene/In_battle.tscn")
	#Enter a battle and change the scene 
	
func _attack_timeout() -> void:
	end_attack()

func _on_chest_opened():
	print("Get heal potion")
	Global.inventory.add_item(Global.items["Heal Potion"])
