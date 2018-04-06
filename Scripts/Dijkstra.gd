extends Node

var priority_queue = Resources.PriorityQueue.new()

func get_tiles_in_range(tile_map3D, start_pos, distance, tile_based_nodes, ignore_nodes):
	#priority_queue.clear()
	var q = []
	var dist = {}
	var prev = {}
	var graph = {}
	var found = {}
	for level in tile_map3D.get_levels():
		var tile_map2D = tile_map3D.get_level(level)
		var tile_map = tile_map2D.get_tile_map()
		for tile2D in tile_map:
			var tile = Vector3(tile2D.x, tile2D.y, level)
			graph[tile] = tile_map3D.get_neighbors(tile)
			#if tile != start_pos:
			dist[tile] = -1
			prev[tile] = null
			q.append(tile)
	dist[start_pos] = 0
	while not q.empty():
		var current_tile = get_least_dist_tile(q, dist, found)
		found[current_tile] = true
		q.pop_front()
		for neighbor_tile in graph[current_tile]:
			if dist[current_tile] == -1:
				dist[current_tile] = 1
			var alt = dist[current_tile] + current_tile.distance_to(neighbor_tile) # 1 could be changed to a varible distance
			if alt < dist[neighbor_tile] or dist[neighbor_tile] == -1:
				dist[neighbor_tile] = alt
				prev[neighbor_tile] = current_tile
	
	var in_range = []
	for tile in dist:
		if dist[tile] <= distance and dist[tile] != -1:
			in_range.append(tile)
	return in_range


func get_least_dist_tile(q, dist, found):
	var least_dist_tile
	for tile in q:
		if least_dist_tile == null or (dist[least_dist_tile] > dist[tile] and dist[least_dist_tile] != -1 and (found.has(tile) and found[tile])):
			least_dist_tile = tile
	return least_dist_tile