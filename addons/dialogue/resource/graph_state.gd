class_name GraphState
extends Resource

var _nodes: Array = []
var _connections: Array = []

func collect_graph_state(graph_edit: GraphEdit):
	_nodes.clear()
	_connections.clear()
	for node in graph_edit.get_children():
		if node is GraphNode:
			var node_info = {
				"id": node.name,  # Use node name or a unique identifier
				"position": node.get_position_offset(),
				"properties": {
					# Add any custom node properties here
				}
			}
			_nodes.append(node_info)

	for connection in graph_edit.get_connection_list():
		var connection_info = {
			"from_node": connection.from_node,
			"from_slot": connection.from_port,
			"to_node": connection.to_node,
			"to_slot": connection.to_port
		}
		_connections.append(connection_info)
	return

func apply_graph_state(graph_edit: GraphEdit, node_scene: PackedScene):
	graph_edit.clear_connections()
	for node_info in _nodes:
		var node = node_scene.instance()
		node.name = node_info["id"]
		node.set_position_offset(node_info["position"])
		# Set additional properties here
		graph_edit.add_child(node)
	for connection_info in _connections:
		graph_edit.connect_node(
			connection_info["from_node"], connection_info["from_slot"],
			connection_info["to_node"], connection_info["to_slot"]
		)
	return
