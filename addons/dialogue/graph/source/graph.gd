@tool
extends GraphEdit

var _saveGraphButton: PackedScene = preload("res://addons/dialogue/graph/subscenes/save_graph.tscn")
var _addNodeButton: PackedScene = preload("res://addons/dialogue/graph/subscenes/add_node.tscn")
var _closeNodeButton: PackedScene = preload("res://addons/dialogue/node/subscenes/close.tscn")
var _vSep: PackedScene = preload("res://addons/dialogue/graph/subscenes/vsep.tscn")
var _graphNode: PackedScene = preload("res://addons/dialogue/node/node.tscn")

var _availableID: Array[int] = []
var _count: int = 1

func _ready() -> void:
	var menu: HBoxContainer = get_menu_hbox()
	var addBtn: Button = _addNodeButton.instantiate()
	var saveBtn: Button = _saveGraphButton.instantiate()
	var vsep: VSeparator = _vSep.instantiate()
	for node in [vsep, saveBtn, addBtn]:
		menu.add_child(node)
		menu.move_child(node, 0)
	addBtn.connect("pressed", on_add)
	saveBtn.connect("pressed", on_save)
	connect("disconnection_request", on_disconnection_request)
	connect("connection_request", on_connection_request)
	connect("delete_nodes_request", on_delete_request)
	return

func on_save() -> void:
	var graph_state: GraphState = GraphState.new()
	graph_state.collect_graph_state(self)
	var err: Error = ResourceSaver.save(graph_state, "res://addons/dialogue/saves/save.res")
	if err:
		push_error(error_string(err))
	return

func on_add() -> void:
	var id: int = 0
	if _availableID.size() > 0:
		id = _availableID.pop_back()
	else:
		id = _count
		_count += 1
	var dialogueNode: GraphNode = _graphNode.instantiate()
	var nodeName: String = "node%d" % id 
	dialogueNode.set_id(id)
	dialogueNode.set_name(nodeName)
	dialogueNode.set_title(nodeName)
	add_child(dialogueNode)
	# adding 'X' top right
	var closeButton: Button = _closeNodeButton.instantiate()
	dialogueNode.get_titlebar_hbox().add_child(closeButton)
	closeButton.connect("pressed", on_close.bind(dialogueNode))
	return

func on_close(dialogueNode: GraphNode) -> void:
	_availableID.append(dialogueNode.get_id())
	dialogueNode.queue_free()
	return

func on_delete_request(nodes: Array[StringName]):
	for n in nodes:
		var path: NodePath = NodePath(n)
		var node: GraphNode = get_node(path)
		on_close(node)
	return

func on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var connections: Array[Dictionary] = get_connection_list()
	for connection in connections:
		if connection["to_node"] == to_node and connection["to_port"] == to_port:
			return # prevent stacking connections
	connect_node(from_node, from_port, to_node, to_port)
	return

func on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)
	return
