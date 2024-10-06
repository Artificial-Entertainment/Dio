class_name GraphState
extends Resource

@export var _nodes: Array[Dictionary] = []
@export var _connections: Array[Dictionary] = []

func collect_graph_state(graphEdit: GraphEdit):
	_nodes.clear()
	for node in graphEdit.get_children():
		if node is GraphNode:
			var nodeInfo: Dictionary = {
				"id": node.get_id(),
				"name": node.get_name(),
				"position": node.get_position_offset(),
			}
			_nodes.append(nodeInfo)
	_connections.clear()
	_connections = graphEdit.get_connection_list()
	return

func apply_graph_state(graphEdit: GraphEdit):
	for node in graphEdit.get_children():
		if node is GraphNode:
			node.queue_free()

	for nodeInfo in _nodes:
		graphEdit.add_graph_node(
			nodeInfo["id"], nodeInfo["name"], 
			nodeInfo["position"]
		)

	for connInfo in _connections:
		graphEdit.connect_node(
			connInfo["from_node"], connInfo["from_port"],
			connInfo["to_node"], connInfo["to_port"]
		)
	return
