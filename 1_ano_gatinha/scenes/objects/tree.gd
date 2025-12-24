extends StaticBody2D
const apple_texture = preload("res://graphics/plants/apple.png")
var health := 3:
	set(value):
		health = value
		if health <= 0:
			$Sprite2D.hide()
			$Stump.show()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12,6)
			$CollisionShape2D.shape = shape
			$CollisionShape2D.position.y = 8

func _ready() -> void:
	create_apple(randi_range(0,2))

func hit(tool: Enum.Tool):
	if tool == Enum.Tool.AXE:
		$Sprite2D.flash()
		get_apple()
		health -= 1


func create_apple(num: int):
	var apple_markers = $AppleSpawnPosition.get_children().duplicate(true)
	for i in num:
		var pos_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() -1))
		var sprite = Sprite2D.new()
		sprite.texture = apple_texture
		$Apples.add_child(sprite)
		sprite.position = pos_marker.position

func get_apple():
	if $Apples.get_children():
		$Apples.get_children().pick_random().queue_free()

func reset():
	for apple in $Apples.get_children():
		apple.queue_free()
	create_apple(randi_range(0,2))
