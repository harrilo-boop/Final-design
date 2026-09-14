extends Area2D

@export var heal_timer: Timer
@export var heal_animation: AnimatedSprite2D

func _player_revive(body) -> void:
	if !body.is_in_group("player"):
		return
	if heal_animation.animation == "full":
		heal_timer.start()
		print("111")
	else:
		print("Out of Charge")


func _player_leave_revive(body) -> void:
	if !body.is_in_group("player"):
		return
	heal_timer.stop()

func _heal_done() -> void:
	Global.player_hp = Global.max_player_hp
	print("Revive Done")
	heal_animation.animation = "null"
	Global.floor_require = true
