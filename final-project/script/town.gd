extends Node2D

var can_trade_1:bool = false
var can_trade_2:bool = false

@export var player: CharacterBody2D
@export var Trade_1: Area2D
@export var Trade_2: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_interact"):
		if can_trade_1 == true:
			print("Weapon & Armor shop opened") #WAIT FOR SHOWING SHOP UI
		elif can_trade_2 == true:
			print("Technique shop opened")

func _leave_town(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")


func _shop_enter(area: Area2D) -> void:
	if area == Trade_1:
		can_trade_1 = true
	elif area == Trade_2:
		can_trade_2 = true


func _shop_leave(area: Area2D) -> void:
	if area == Trade_1 or area == Trade_2:
		can_trade_1 = false
		can_trade_2 = false
