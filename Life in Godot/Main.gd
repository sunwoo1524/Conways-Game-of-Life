extends Node

export var width = 600
export var height = 600
var cell_size = 8
var play = false
var fill = true

func _physics_process(delta):
	if Input.is_action_just_pressed("play_toggle"):
		if play:
			$Timer.stop()
		else:
			$Timer.start()
		play = !play
	
	var mouse_position = $Grid.get_global_mouse_position()
	var cell_position = $Grid.world_to_map(mouse_position)
	var cell = $Grid.get_cellv(cell_position)
	
	if Input.is_action_just_pressed("click_set_tile"):
		if cell == $Grid.INVALID_CELL:
			fill = true
		else:
			fill = false
	
	if Input.is_action_pressed("click_set_tile"):
		if fill:
			$Grid.set_cellv(cell_position, 0)
		else:
			$Grid.set_cellv(cell_position, $Grid.INVALID_CELL)

func _on_Timer_timeout():
	var grid_width = width / cell_size
	var grid_height = height / cell_size
	var temp_map = []
	
	temp_map.resize(grid_height)
	var temp = []
	temp.resize(grid_width)
	temp.fill(0)
	temp_map.fill(temp)
	
	for y in grid_height:
		for x in grid_width:
			var cell = $Grid.get_cellv(Vector2(x, y))
			
			if cell == $Grid.INVALID_CELL:
				temp_map[y][x] = 0
			else:
				temp_map[y][x] = 1
	
	for y in grid_height:
		for x in grid_width:
			var cell = $Grid.get_cellv(Vector2(x, y))
			var cells_num = 0
			
			for dy in range(y - 1, y + 2):
				for dx in range(x - 1, x + 2):
					if x == dx and y == dy:
						continue
					elif $Grid.get_cellv(Vector2(dx, dy)) != $Grid.INVALID_CELL:
						cells_num += 1
			
			if cells_num >= 0 and cells_num <= 1:
				temp_map[y][x] = 0
			elif cells_num >= 2 and cells_num <= 3:
				if cell == $Grid.INVALID_CELL and cells_num == 3:
					temp_map[y][x] = 1
				else:
					temp_map[y][x] = 1
			else:
				temp_map[y][x] = 0
	for y in grid_height:
		for x in grid_width:
			if temp_map[y][x] == 0:
				$Grid.set_cell(x, y, $Grid.INVALID_CELL)
			else:
				$Grid.set_cell(x, y, 0)
