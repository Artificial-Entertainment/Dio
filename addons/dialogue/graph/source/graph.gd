@tool
extends GraphEdit

var _loadGraphButton: PackedScene = preload("res://addons/dialogue/graph/subscenes/load_graph.tscn")
var _saveGraphButton: PackedScene = preload("res://addons/dialogue/graph/subscenes/save_graph.tscn")
var _addNodeButton: PackedScene = preload("res://addons/dialogue/graph/subscenes/add_node.tscn")
var _vSep: PackedScene = preload("res://addons/dialogue/graph/subscenes/vsep.tscn")
var _graphNode: PackedScene = preload("res://addons/dialogue/node/node.tscn")
@export var _fileDialog: FileDialog

var _availableID: Array[int] = []
var _count: int = 1

func _ready() -> void:
	var addBtn: Button = _addNodeButton.instantiate()
	var saveBtn: Button = _saveGraphButton.instantiate()
	var loadBtn: Button = _loadGraphButton.instantiate()
	var vsep: VSeparator = _vSep.instantiate()
	var menu: HBoxContainer = get_menu_hbox()
	for node in [vsep, loadBtn, saveBtn, addBtn]:
		menu.add_child(node)
		menu.move_child(node, 0)
	addBtn.pressed.connect(on_add)
	saveBtn.pressed.connect(_fileDialog.preset.bind("save"))
	loadBtn.pressed.connect(_fileDialog.preset.bind("load"))
	disconnection_request.connect(on_disconnection_request)
	connection_request.connect(on_connection_request)
	delete_nodes_request.connect(on_delete_request)
	return

func add_graph_node(id: int, nodeName: String, position: Vector2) -> void:
	var dialogueNode: GraphNode = _graphNode.instantiate()
	dialogueNode.set_id(id)
	dialogueNode.set_name(nodeName)
	dialogueNode.set_title(nodeName)
	dialogueNode.set_position_offset(position)
	add_child(dialogueNode)
	return

func on_add() -> void:
	var id: int = 0
	if _availableID.size() > 0:
		id = _availableID.pop_back()
	else:
		id = _count
		_count += 1
	var nodeName: String = "node%d" % id
	add_graph_node(id, nodeName, Vector2.ZERO)
	return

func on_delete(dialogueNode: GraphNode) -> void:
	_availableID.append(dialogueNode.get_id())
	dialogueNode.queue_free()
	return

func on_delete_request(nodes: Array[StringName]):
	for n in nodes:
		var path: NodePath = NodePath(n)
		var node: GraphNode = get_node(path)
		on_delete(node)
	return

func on_connection_request(fNode: StringName, fPort: int, tNode: StringName, tPort: int) -> void:
	var connections: Array[Dictionary] = get_connection_list()
	for connection in connections:
		if connection["to_node"] == tNode and connection["to_port"] == tPort:
			return # prevent stacking connections
	connect_node(fNode, fPort, tNode, tPort)
	return

func on_disconnection_request(fNode: StringName, fPort: int, tNode: StringName, tPort: int) -> void:
	disconnect_node(fNode, fPort, tNode, tPort)
	return
