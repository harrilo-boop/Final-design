extends Area2D

func _on_chest_opened(body, item: item_resource):
	print("Get Heal Potion")
	if !body.is_in_group("player"):
		return
	if Global.inventory == item.max_stack_size:
		Global.inventory.add_item(Global.items["Heal Potion"])
#	queue_free()
