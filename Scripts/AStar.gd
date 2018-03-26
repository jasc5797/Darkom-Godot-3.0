extends Node2D

var priority_queue = Resources.PriorityQueue.new()

var show_circles = false

#Add handling for unreachable tiles
var circles = []

func get_path(tile_map3D, start_pos, goal_pos, tile_based_nodes):
	circles.clear()
	set_as_toplevel(true)
	z_index = 100
	priority_queue.clear()
	priority_queue.put(start_pos, 0)
	#Key: Tile, Value: Previous Tile
	var came_from = {}
	#Key: Tile, Value: Cost
	var cost = {}
	came_from[start_pos] = null
	cost[start_pos] = 0
	if node_at_pos(tile_based_nodes, goal_pos):
		return []
	while not priority_queue.empty():
		var current_pos = priority_queue.pop()
		if show_circles:
			circles.append(current_pos)
			update()
		#Break if the goal has been reached
		if current_pos == goal_pos:
			break
		# Get tile neighbors
		var current_neighbors = tile_map3D.get_neighbors(current_pos)#get_neighbors(tile_map3D, current_pos)
		for neighbor_pos in current_neighbors:
			var new_cost = cost[current_pos] + get_cost(current_pos, neighbor_pos)
			if not node_at_pos(tile_based_nodes, neighbor_pos) and (not cost.keys().has(neighbor_pos) or new_cost < cost[neighbor_pos]):
				cost[neighbor_pos] = new_cost
				var priority = new_cost + get_heuristic(goal_pos, neighbor_pos)
				priority_queue.put(neighbor_pos, priority)
				came_from[neighbor_pos] = current_pos
	return get_reconstructed_path(came_from, start_pos, goal_pos)

func node_at_pos(tile_based_nodes, tile_pos3D):
	for node in tile_based_nodes:
		if node.get_tile_pos3D() == tile_pos3D and node.collidable:
			return true
	return false

func _draw():
	for tile_pos3D in circles:
		var color = circles.find(tile_pos3D) * 1.0 / circles.size()
		print(color)
		var tile_size = Vector2(64, 32)
		var x = tile_pos3D.x * tile_size.x / 2 - tile_pos3D.y * tile_size.x / 2
		var y = tile_pos3D.x * tile_size.y / 2 + tile_pos3D.y * tile_size.y / 2 - tile_pos3D.z * tile_size.y
		draw_circle(Vector2(x, y) + Vector2(0, 15), 10.0, Color(1 - color, color, 0))

func get_heuristic(start_pos, goal_pos):
	#Manhattan distance formula
	return abs(start_pos.x - goal_pos.x) + abs(start_pos.y - goal_pos.y) + abs(start_pos.z - goal_pos.z)

func get_cost(current_pos, neighbor_pos):
	#Diagonals are given slightly higher cost to stop character from walking in zig zag. Needs testing/proof?
	if current_pos.x == neighbor_pos.x or current_pos.y == neighbor_pos.y:
		return 10
	return 14

func get_reconstructed_path(came_from, start_pos, goal_pos):
	var current_pos = goal_pos
	var path = [current_pos]
	while current_pos != start_pos:
		current_pos = came_from[current_pos]
		path.append(current_pos)
	path.invert()
	return path
