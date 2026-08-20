extends Area2D

@export var item_animation: AnimatedSprite2D


func _on_chest_opened(body):
	if !body.is_in_group("player"):
		return
	print("Get Heal Potion")
	Global.inventory.add_item(Global.items["Heal Potion"])
	Global.inventory.add_item(Global.items["Strong Heal Potion"])
	Global.inventory.add_item(Global.items["Rare Heal Potion"])
	Global.inventory.add_item(Global.items["Super Rare Heal Potion"])
	Global.inventory.add_item(Global.items["Technique Point Potion"])
	Global.inventory.add_item(Global.items["Strong Technique Potion"])
	Global.inventory.add_item(Global.items["Temporary Sheild"])
	item_animation.play("opened")
