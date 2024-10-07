@tool
class_name GraphState extends Resource

@export var _nextID  = 1
@export var _availableID: Array[int] = []
@export var _nodes: Array[Dictionary] = []
@export var _connections: Array[Dictionary] = []

func collect_graph_state(graph: GraphEdit) -> void:
	_nodes.clear()
	for node in graph.get_children():
		if node is GraphNode:
			var nodeInfo: Dictionary = {
				"id": node.get_id(),
				"name": node.get_name(),
				"position": node.get_position_offset(),
			}
			_nodes.append(nodeInfo)

	_connections.clear()
	_connections = graph.get_connection_list()
	_nextID = graph.get_next_id()
	_availableID = graph.get_id_array()
	return

func apply_graph_state(graph: GraphEdit) -> void:
	for node in graph.get_children():
		if node is GraphNode:
			graph.remove_child(node)
			node.queue_free()

	for nodeInfo in _nodes:
		graph.add_graph_node(
			nodeInfo["id"], nodeInfo["name"], 
			nodeInfo["position"]
		)

	for connInfo in _connections:
		graph.connect_node(
			connInfo["from_node"], connInfo["from_port"],
			connInfo["to_node"], connInfo["to_port"]
		)

	graph.set_next_id(_nextID)
	graph.set_id_array(_availableID)
	return
