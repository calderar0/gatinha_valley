extends Button

var item_enum
var shop_type: Enum.Shop
var unlock: Array
const ICON_PATHS = {
	Enum.Item.WOOD: "res://graphics/icons/wood.png",
	Enum.Item.FISH: "res://graphics/icons/goldfish.png",
	Enum.Item.APPLE: "res://graphics/icons/apple.png",
	Enum.Item.CORN: "res://graphics/icons/corn.png",
	Enum.Item.WHEAT: "res://graphics/icons/wheat.png",
	Enum.Item.PUMPKIN: "res://graphics/icons/pumpkin.png",
	Enum.Item.TOMATO: "res://graphics/icons/tomato.png"}

signal press(shop_type: Enum.Shop)

func setup(new_shop_type, new_item_enum, parent):
	item_enum = new_item_enum
	shop_type = new_shop_type
	parent.add_child(self)
	var source = Data.STYLE_UPGRADES if shop_type == Enum.Shop.HAT else Data.MACHINE_UPGRADE_COST
	var data =  source[item_enum]
	unlock = Data.unlocked_machines if shop_type == Enum.Shop.MAIN else Data.unlocked_styles
	$VBoxContainer/VBoxContainer/Label.text = data['name']
	$VBoxContainer/ColorRect.color = data['color']
	$VBoxContainer/ColorRect/TextureRect.texture = data['icon']
	$VBoxContainer/VBoxContainer/Control/HBoxContainer/HBoxContainer/Label.text = str(data['cost'].values()[0])
	$VBoxContainer/VBoxContainer/Control/HBoxContainer/HBoxContainer2/Label.text = str(data['cost'].values()[1])
	var icon_1 = load(ICON_PATHS[data['cost'].keys()[0]])
	var icon_2 = load(ICON_PATHS[data['cost'].keys()[1]])
	$VBoxContainer/VBoxContainer/Control/HBoxContainer/HBoxContainer/TextureRect.texture = icon_1
	$VBoxContainer/VBoxContainer/Control/HBoxContainer/HBoxContainer2/TextureRect.texture = icon_2


func _on_focus_entered() -> void:
	$BG.theme_type_variation = "FocusPanel"


func _on_focus_exited() -> void:
	$BG.theme_type_variation = ""


func _on_pressed() -> void:
	unlock.append(item_enum)
	press.emit(shop_type)
