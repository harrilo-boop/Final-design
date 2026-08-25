extends CharacterBody2D

class_name Player
#THE PLAYER SCRIPT WITH OVERWORLD SETTINGS

var speed:float = 500
var is_attacking = false
var open_itembox: bool = false
var return_from_battle:bool = true
var last_direction: Vector2 = Vector2.DOWN
var hitbox_offset: Vector2
var last_position: Vector2 = Vector2(0,0)
var battle_entered_by:String = ""
var current_floor:int = 0

@export var player: CharacterBody2D
@export var pivot: Marker2D
@export var sword_area: Area2D
@export var sword_collision: CollisionShape2D
@export var timer: Timer
@export var animatesprite: AnimatedSprite2D
@export var current_level: Label

func _ready() -> void:
	sword_area.monitoring = false
	sword_collision.disabled = true
	hitbox_offset = sword_area.position

	if Global.last_position != Vector2.ZERO:
		global_position = Global.last_position
		Global.last_position = Vector2.ZERO
	Global.last_position = Vector2.ZERO
	
func _process(_delta: float) -> void:
	move_player()
	if Input.is_action_just_pressed("ui_attack") and not is_attacking:
		_start_attack()
	if Input.is_action_just_pressed("ui_pause"):
		Global.last_position = global_position
		get_tree().call_deferred("change_scene_to_file", "res://scenes/UI_scene/Pause_menu.tscn")
	if Input.is_action_just_pressed("ui_run"):
		speed = speed * 1.2
	elif Input.is_action_just_released("ui_run"):
		speed = speed / 1.2
	current_floor = Global.current_floor
	current_level.text = str(current_floor)

func _on_spawn(_direction: String) -> void:
	global_position = position

#Control player by the input
func move_player() -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		direction.y = 0
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		direction.x = 0
	else:
		direction = Vector2.ZERO
	if direction != Vector2.ZERO:
		velocity = speed * direction.normalized()
		last_direction = direction
		update_hitbox_offset()
		update_animation(direction)
	else:
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO)
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


#Finding which direction for animation movement
func update_animation(direction: Vector2) -> void:
	if animatesprite == null:
		return
	if direction == Vector2.ZERO and not is_attacking:
		animatesprite.stop()
		return
	if abs(direction.x) > abs(direction.y):
		animatesprite.animation = "left"
		if direction.x > 0:
			animatesprite.flip_h = true   
		else:
			animatesprite.flip_h = false  
	else:
		animatesprite.flip_h = false
		if direction.y > 0:
			animatesprite.animation = "down"
		else:
			animatesprite.animation = "up"
	animatesprite.play()

#Finding which direction for animation attack
func update_attack_animation() -> void:
	if animatesprite == null:
		return
	if abs(last_direction.x) > abs(last_direction.y):
		animatesprite.play("left_attack")
		if last_direction.x > 0:
			animatesprite.flip_h = true
		else:
			animatesprite.flip_h = false
	else:
		animatesprite.flip_h = false
		if last_direction.y > 0:
			animatesprite.play("down_attack")
		else:
			animatesprite.play("up_attack")

#The attack starts
func _start_attack() -> void:
	update_attack_animation()
	is_attacking = true

#The attack stops
func end_attack() -> void:
	if "attack" in animatesprite.animation:
		is_attacking = false
	sword_area.monitoring = true
	sword_collision.disabled = false
	timer.start()

#Detecting what is the player attacked
func _on_sword_hit(body: Node) -> void:
	if body == self:
		return
	if body.is_in_group("Enemy"):
		_enter_battle()

func _attack_to_battle() -> void:
	sword_area.monitoring = false
	sword_collision.disabled = true
	
	
#Enter a battle and change the scene 
func _enter_battle() -> void: 
	Global.last_position = global_position
	battle_entered_by = "player"
	Global.battle_entered_by = battle_entered_by
	get_tree().call_deferred("change_scene_to_file", "res://scenes/UI_scene/In_battle.tscn")
