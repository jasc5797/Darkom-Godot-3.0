extends Node

var queue = []
var priority = []

func pop():
	var item = queue.front()
	queue.pop_front()
	priority.pop_front()
	return item

#Sorts array so that the front has the highest priorty (lowest number)
func put(var item, var item_priority):
	if empty():
		queue.append(item)
		priority.append(item_priority)
	else:
		var placed = false
		for index in range(priority.size()):
			if priority[index] > item_priority and not placed:
				queue.insert(index, item)
				priority.insert(index, item_priority)
				placed = true
		if not placed:
			queue.append(item)
			priority.append(item_priority)

func empty():
	return queue.empty()

func clear():
	queue.clear()
	priority.clear()