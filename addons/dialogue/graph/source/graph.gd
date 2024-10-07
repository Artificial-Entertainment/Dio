@tool
extends GraphEdit

const LOAD_GRAPH_BUTTON: PackedScene = preload("res://addons/dialogue/graph/subscenes/load_graph.tscn")
const SAVE_GRAPH_BUTTON: PackedScene = preload("res://addons/dialogue/graph/subscenes/save_graph.tscn")
const ADD_NODE_BUTTON: PackedScene = preload("res://addons/dialogue/graph/subscenes/add_node.tscn")
const V_SEP: PackedScene = preload("res://addons/dialogue/graph/subscenes/vsep.tscn")
const GRAPH_NODE: PackedScene = preload("res://addons/dialogue/node/node.tscn")
@export var _fileDialog: FileDialog

var _availableID: Array[int] = []
var _nextID: int = 1

func _ready() -> void:
	var addBtn: Button = ADD_NODE_BUTTON.instantiate()
	var saveBtn: Button = SAVE_GRAPH_BUTTON.instantiate()
	var loadBtn: Button = LOAD_GRAPH_BUTTON.instantiate()
	var vsep: VSeparator = V_SEP.instantiate()
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

func add_graph_node(id: int, nodeName: String, pos: Vector2) -> void:
	var dialogueNode: GraphNode = GRAPH_NODE.instantiate()
	dialogueNode.set_id(id)
	dialogueNode.set_name(nodeName)
	dialogueNode.set_title(nodeName)
	dialogueNode.set_position_offset(pos)
	add_child(dialogueNode)
	return

func on_add() -> void:
	var id: int = 0
	if _availableID.size() > 0:
		id = _availableID.pop_back()
	else:
		id = _nextID
		_nextID += 1
	var nodeName: String = "node%d" % id
	add_graph_node(id, nodeName, Vector2.ZERO)
	return

func on_delete(dialogueNode: GraphNode) -> void:
	_availableID.append(dialogueNode.get_id())
	dialogueNode.queue_free()
	return


func on_delete_request(nodes: Array[StringName]):
	for n in nodes:
		on_delete(get_node(NodePath(n)))
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
