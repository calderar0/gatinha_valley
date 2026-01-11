extends CharacterBody2D

var player: CharacterBody2D

@export var dialog: Array[String]
@export var fin_dialog: String
@export var texture: Texture2D
@export var shop_type: Enum.Shop
@export var vframe: int
@export var has_fin_animation: bool
@export var npc: bool = true
var dialog_index: int

signal open_shop(shop_type: Enum.Shop)

func _ready() -> void:
	$Sprite2D.texture = texture
	$Sprite2D.vframes = vframe
		


func _process(_delta: float) -> void:
	if player:
		if player.position.distance_to(position) > 30:
			$Dialog.hide()
			dialog_index = 0

func interact(player_character: CharacterBody2D):
	player = player_character
	
	var raw_dir = (player_character.position - position).normalized()
	var dir = Vector2i(round(raw_dir.x), round(raw_dir.y))
	$Sprite2D.frame_coords.y = {
		Vector2i.DOWN: 0,
		Vector2i.LEFT: 1,
		Vector2i.RIGHT: 2,
		Vector2i.UP: 3,
	}[dir]
	$Dialog.show()
	if dialog_index < dialog.size():
		$Dialog.set_text(dialog[dialog_index])
		dialog_index += 1
	else:
		if Data.shop_connection[shop_type]['tracker'].size() == Data.shop_connection[shop_type]['all'].size():
			$Dialog.set_text(fin_dialog)
			if has_fin_animation:
				var tween = create_tween()
				tween.tween_property($Sprite2D, 'frame', 23, 1.6).from(16)
				tween.tween_property($Sprite2D, 'frame', 0, 0)
		else:
			$Dialog.hide()
			dialog_index = 0
			if npc:
				open_shop.emit(shop_type)
				get_tree().get_first_node_in_group('ResourceUI').reveal(false)
	
