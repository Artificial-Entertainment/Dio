@tool
class_name GraphState extends Resource

## The next available ID for new nodes
@export var _nextID: int = 0
## Array of IDs that have become available due to node deletion
@export var _availableID: Array[int] = []
## Array of dictionaries containing information about each node in the graph
@export var _nodes: Array[Dictionary] = []
## Array of dictionaries containing information about connections between nodes
@export var _connections: Array[Dictionary] = []

func get_dialogue() -> Dictionary:
	var dialogue: Dictionary = {}
	for node in _nodes:
		dialogue[node["name"]] = {
			"name": node["name"],
			"text": node["text"],
			"choices": node["choices"],
			"connections": []
		}
	for connection in _connections:
		var from_node: StringName = connection["from_node"]
		var to_node: StringName = connection["to_node"]
		dialogue[from_node]["connections"].append(to_node)
	return dialogue

func collect_graph_state(graph: GraphEdit) -> void:
	_nodes.clear()
	for node in graph.get_children():
		if node is GraphNode:
			var nodeInfo: Dictionary = {
				"id": node.get_id(),
				"name": node.get_name(),
				"text": node.get_text(),
				"choices": node.get_choices(),
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
			nodeInfo["id"], nodeInfo["name"], nodeInfo["text"], 
			nodeInfo["choices"] as PackedStringArray, nodeInfo["position"],
		)

	for connInfo in _connections:
		graph.connect_node(
			connInfo["from_node"], connInfo["from_port"],
			connInfo["to_node"], connInfo["to_port"]
		)

	graph.set_next_id(_nextID)
	graph.set_id_array(_availableID)
	return
