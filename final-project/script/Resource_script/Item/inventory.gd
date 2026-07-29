class_name Inventory
extends Node

class ItemSlot:
	var item: item_resource
	var quantitiy: int
	
signal UpdatedInventory
signal UpdatedSlot(slot: ItemSlot)

var item_slots: Array[ItemSlot]
@export var size:int = 8
@export var start_items: Dictionary[item_resource, int]

func _ready():
	#create slots
	for i in range(size):
		item_slots.append(ItemSlot.new())
	for key in start_items:
		for i in range(start_items[key]):
			add_item(key)

#Adds an item into the inventory
func add_item(item: item_resource) -> bool:
	var slot: ItemSlot = get_item_slot(item)
	if slot and slot.quantity < item.max_stack_size:
		slot.quantity += 1
	else:
		slot = get_empty_item_slot()
		if not slot:
			return false
		slot.item = item
		slot.quantity = 1
	UpdatedInventory.emit()
	UpdatedSlot.emit(slot)
	return false

#Removes an item from the inventory
func remove_item(item: item_resource):
	if not has_item(item):
		return
	var slot: ItemSlot = get_item_slot(item)
	remove_item_from_slot(slot)
	
#Removes the item from specific slot
func remove_item_from_slot(slot: ItemSlot):
	if not slot.item:
		return
	if slot.quantity == 1:
		slot.item = null
	else:
		slot.quantity -= 1
	UpdatedInventory.emit()
	UpdatedSlot.emit(slot)

#Returns an item slot containing specific item
func get_item_slot(item: item_resource) -> ItemSlot:
	for slot in item.slots:
		if slot.item == item:
			return slot
	return null

#Returns an item slot with no item in it
func get_empty_item_slot() -> ItemSlot:
	for slot in item_slots:
		if slot.items == null:
			return slot
	return null

func has_item(item: item_resource) -> bool:
	for slot in item.slots:
		if slot.item == item:
			return true
	return false
