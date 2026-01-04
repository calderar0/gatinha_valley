extends CharacterBody2D

var direction: Vector2
var push_distance:= 130
var push_direction: Vector2
var speed:= 20
var health:= 3:
	set(value):
		health = value
		if health <= 0:
			death()
@onready var player = get_tree().get_first_node_in_group('Player')

func _physics_process(_delta: float) -> void:
	direction = (player.position - position).normalized()
	velocity = direction * speed + push_direction
	move_and_slide()

func push(dir = Vector2.ZERO):
	var tween = get_tree().create_tween()
	var target_dir = dir if dir else (player.position - position).normalized()
	var target = target_dir * -1 * push_distance if not dir else dir
	tween.tween_property(self, "push_direction", target, 0.1)
	tween.tween_property(self, "push_direction", Vector2.ZERO, 0.2)

func death():
	speed = 0
	$AnimationPlayer.current_animation = 'explode'
	

func hit(tool: Enum.Tool, dir = Vector2.ZERO):
	if tool == Enum.Tool.SWORD:
		$Sprite2D.flash()
		push(dir)
		health -= 1
