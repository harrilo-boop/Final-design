extends Node2D

var can_trade_1:bool = false
var can_trade_2:bool = false

@export var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_trade_1 == true and Input.is_action_just_pressed("ui_interact"):
		print("Weapon & Armor shop opened")
	elif can_trade_2 == true and Input.is_action_just_pressed("ui_interact"):
		print("Technique shop opened")

func _leave_town(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")

func _WAshop_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		can_trade_1 = true
		
func _WAshop_leave(body: Node2D) -> void:
	if body is CharacterBody2D:
		can_trade_1 = false
	
func _Tshop_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		can_trade_2 = true
		
func _Tshop_leave(body: Node2D) -> void:
	if body is CharacterBody2D:
		can_trade_2 = false
