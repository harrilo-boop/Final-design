extends CharacterBody2D

var speed:float = 2500
var player: CharacterBody2D

@export var attack_area_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player"):
		player = node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#@if not player == null:
		#look_at(player.global_position)
	#	velocity = Vector2(1, 0).rotated(rotation) * speed
	pass
	
