extends Node2D

var plant_scene = preload("res://scenes/objects/plant.tscn")
var used_cells: Array[Vector2i]
@onready var player = $Objects/Player
@onready var daytransition_material = $Overlay/CanvasLayer/DayTransitionLayer.material
@export var daytime_color: Gradient

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE), int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	var has_soil = grid_coord in $Layers/SoilLayer.get_used_cells()
	match tool:
		Enum.Tool.HOE:
			var cell = $Layers/GrassLayer.get_cell_tile_data(grid_coord) as TileData 
			if cell and cell.get_custom_data('farmable'):
				$Layers/SoilLayer.set_cells_terrain_connect([grid_coord], 0, 0)
		
		Enum.Tool.WATER:
			if has_soil:
				if not $Layers/WaterSoilLayer.get_cell_tile_data(grid_coord):
					$Layers/WaterSoilLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2), 0))
		
		Enum.Tool.FISH:
			if not grid_coord in $Layers/GrassLayer.get_used_cells():
				print("pescando")
			else:
				print("nao to pescando caraio") 
		
		Enum.Tool.SEED:
			if has_soil and grid_coord not in used_cells:
				var plant_res = PlantResource.new()
				plant_res.setup(player.current_seed)
				var plant = plant_scene.instantiate()
				plant.setup(grid_coord, $Objects, plant_res)
				used_cells.append(grid_coord)
				
		Enum.Tool.AXE, Enum.Tool.SWORD:
			for object in get_tree().get_nodes_in_group('Objects'):
				if object.position.distance_to(pos) < 20:
					object.hit(tool)
			
		#Enum.Tool.SWORD:
			#pass

func _process(delta: float) -> void:
	var daytimer_point = 1 - $Timers/DayLenghtTimer.time_left / $Timers/DayLenghtTimer.wait_time
	var color = daytime_color.sample(daytimer_point)
	$Overlay/DaytimeColor.color = color
	if Input.is_action_just_pressed('day_change'):
		day_restart()

func day_restart():
	var tween = create_tween()
	tween.tween_property(daytransition_material, 'shader_parameter/progress', 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(level_reset)
	tween.tween_property(daytransition_material, 'shader_parameter/progress', 0.0, 1.0)

func level_reset():
	for plant in get_tree().get_nodes_in_group('Plants'):
		plant.grow(plant.coord in $Layers/WaterSoilLayer.get_used_cells())
	$Layers/WaterSoilLayer.clear()
	$Timers/DayLenghtTimer.start()
	for object in get_tree().get_nodes_in_group('Objects'):
		if 'reset' in object:
			object.reset()
