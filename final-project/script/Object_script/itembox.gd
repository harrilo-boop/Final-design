extends Area2D

@export var item_animation: AnimatedSprite2D

func _on_chest_opened(body):
	if !body.is_in_group("player"):
		return
	if item_animation.animation == "default":
		normal_chest_open()
	elif item_animation.animation == "rare_default":
		rare_chest_open()
		
func normal_chest_open():
	print("Get Heal Potion and Tp Potion")
	Global.inventory.add_item(Global.items["Heal Potion"])
	Global.inventory.add_item(Global.items["Technique Point Potion"])
	item_animation.play("opened")

func rare_chest_open():
	print("Get Attack Up Potion and Wood Sheild")
	Global.inventory.add_item(Global.items["Attack Up Potion"])
	Global.inventory.add_item(Global.items["Wood Sheild"])
	item_animation.play("rare_opened")
