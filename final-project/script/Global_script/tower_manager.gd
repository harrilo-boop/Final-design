extends Node

var current_floor:int = 0
var max_floor:int = 50
var floor_number:int
var floor_tag:String = ""
@export var level_resource: Resource


func _ready() -> void:
	Global.current_floor = current_floor

func next_floor() -> void:
	if current_floor < max_floor:
		current_floor += 1
		Global.current_floor = current_floor
