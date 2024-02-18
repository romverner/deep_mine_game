extends Resource

class_name Inventory

@export var items: Array[InventoryItem] = []
@export var resources: Array[InventoryItem] = []
@export var money: int = 0

var tracking: Dictionary = {
	'resources_sold': []
}
