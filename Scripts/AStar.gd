extends Node

var priority_queue = Resources.PriorityQueue.new()

#Add handling for unreachable tiles

func get_path(tile_map3D, start_pos, goal_pos):
	priority_queue.clear()
	priority_queue.put(start_pos, 0)
	#Key: Tile, Value: Previous Tile
	var came_from = {}
	#Key: Tile, Value: Cost
	var cost = {}
	came_from[start_pos] = null
	cost[start_pos] = 0
	while not priority_queue.empty():
		var current_pos = priority_queue.pop()
		#Break if the goal has been reached
		if current_pos == goal_pos:
			break
		# Get tile neighbors
		var current_neighbors = tile_map3D.get_neighbors(current_pos)#get_neighbors(tile_map3D, current_pos)
		for neighbor_pos in current_neighbors:
			var new_cost = cost[current_pos] + get_cost(current_pos, neighbor_pos)
			if not cost.keys().has(neighbor_pos) or new_cost < cost[neighbor_pos]:
				cost[neighbor_pos] = new_cost
				var priority = new_cost + get_heuristic(goal_pos, neighbor_pos)
				priority_queue.put(neighbor_pos, priority)
				came_from[neighbor_pos] = current_pos
	return get_reconstructed_path(came_from, start_pos, goal_pos)

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
