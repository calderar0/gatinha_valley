extends Control

var count: int = 0

@onready var container_textos: MarginContainer = $Control/PanelContainer/MarginContainer

func _ready() -> void:
	update_ui()

func _on_texture_button_pressed() -> void:
	if count > 0:
		count -= 1
		update_ui()

func _on_texture_button_2_pressed() -> void:
	var total_paginas = container_textos.get_child_count()
	
	if count < total_paginas - 1:
		count += 1
		update_ui()

func _on_texture_button_3_pressed() -> void:
	hide()

func update_ui() -> void:
	var labels = container_textos.get_children()
	for i in range(labels.size()):
		var label_atual = labels[i]
		if i == count:
			label_atual.visible = true
		else:
			label_atual.visible = false
