extends Node

var priority_queue = Resources.PriorityQueue.new()

var INFINITY = 10000000

func get_tiles_in_range(tile_map3D, start_pos, distance, tile_based_nodes, ignore_nodes):
	var graph = tile_map3D.get_all_tile_pos3D()
	var unexplored = []
	var dist = {}
	var prev = {}
	for tile_pos3D in graph:
		dist[tile_pos3D] = INFINITY
		prev[tile_pos3D] = null
		unexplored.append(tile_pos3D)
	dist[start_pos] = 0
	while not unexplored.empty():
		var current_tile_pos3D = get_min_dist_tile(unexplored, dist)
		var index = unexplored.find(current_tile_pos3D)
		unexplored.remove(index)
		var neighbors = tile_map3D.get_neighbors(current_tile_pos3D)
		for neighbor_tile_pos3D in neighbors:
			var alt = dist[current_tile_pos3D] + get_length(current_tile_pos3D, neighbor_tile_pos3D)
			if alt < dist[neighbor_tile_pos3D]:
				dist[neighbor_tile_pos3D] = alt
				prev[neighbor_tile_pos3D] = current_tile_pos3D
	var tiles_in_range = []
	for tile_pos3D in dist:
		if dist[tile_pos3D] <= distance:
			tiles_in_range.append(tile_pos3D)
	return tiles_in_range

func get_min_dist_tile(unexplored, dist):
	var min_dist_tile
	for tile_pos3D in unexplored:
		if min_dist_tile == null or dist[min_dist_tile] > dist[tile_pos3D]:
			min_dist_tile = tile_pos3D
	return min_dist_tile

func get_length(current_tile, neighbor_tile):
	return 1#current_tile.distance_to(neighbor_tile)