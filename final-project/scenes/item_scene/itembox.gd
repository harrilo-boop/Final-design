extends Area2D

func _on_chest_opened(body):
	print("Get Heal Potion")
	if !body.is_in_group("player"):
		return
	Global.inventory.add_item(Global.items["Heal Potion"])
	queue_free()
