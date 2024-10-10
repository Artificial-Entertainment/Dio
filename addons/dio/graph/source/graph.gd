@tool
extends GraphEdit

const LOAD_GRAPH_BUTTON: PackedScene = preload("res://addons/dio/graph/subscenes/load_graph.tscn")
const SAVE_GRAPH_BUTTON: PackedScene = preload("res://addons/dio/graph/subscenes/save_graph.tscn")
const ADD_NODE_BUTTON: PackedScene = preload("res://addons/dio/graph/subscenes/add_node.tscn")
const V_SEP: PackedScene = preload("res://addons/dio/graph/subscenes/vsep.tscn")
const GRAPH_NODE: PackedScene = preload("res://addons/dio/node/graph_node.tscn")
@export var _fileDialog: FileDialog

var _availableID: Array[int] = []
var _nextID: int = 1

func _ready() -> void:
	# Assert that FileDialog is set
	assert(_fileDialog != null, "FileDialog is not set")
	# Instantiate UI elements
	var saveBtn: Button = SAVE_GRAPH_BUTTON.instantiate()
	var loadBtn: Button = LOAD_GRAPH_BUTTON.instantiate()
	var addBtn: Button = ADD_NODE_BUTTON.instantiate()
	var vsep: VSeparator = V_SEP.instantiate()
	var menu: HBoxContainer = get_menu_hbox()
	# Add UI elements to the menu
	for node in [vsep, loadBtn, saveBtn, addBtn]:
		menu.add_child(node)
		menu.move_child(node, 0)
	# Connect button signals
	addBtn.pressed.connect(on_add)
	saveBtn.pressed.connect(_fileDialog.preset.bind("save"))
	loadBtn.pressed.connect(_fileDialog.preset.bind("load"))
	# Connect graph signals
	disconnection_request.connect(on_disconnection_request)
	connection_request.connect(on_connection_request)
	delete_nodes_request.connect(on_delete_request)
	return

# Drag and drop GraphState
func _can_drop_data(position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("files")

func _drop_data(pos: Vector2, data: Variant) -> void:
	if data.files.size() > 0:
		_fileDialog.process_open_file(data.files[0])
	return

# Graph
func add_graph_node(id: int, nodeName: String, text: String, choices: PackedStringArray, pos: Vector2) -> void:
	var dialogueNode: GraphNode = GRAPH_NODE.instantiate()
	dialogueNode.set_id(id)
	dialogueNode.set_text(text)
	dialogueNode.set_name(nodeName)
	dialogueNode.set_title(nodeName)
	dialogueNode.set_choices(choices)
	dialogueNode.set_position_offset(pos)
	add_child(dialogueNode)
	dialogueNode.choice_removed.connect(on_choice_removed)
	return

# Disconnect choice before removing it, prevent null pointer
func on_choice_removed(node: GraphNode, port: int) -> void:
	var connections: Array[Dictionary] = get_connection_list()
	for conn in connections:
		if conn["from_node"] == node.get_name() and conn["from_port"] == port:
			disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
	return

func on_add() -> void:
	var id: int = 0
	if _availableID.size() > 0:
		id = _availableID.pop_front()
	else:
		id = _nextID
		_nextID += 1
	add_graph_node(id, "node%d" % id, "Response Text", [], Vector2.ZERO)
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
	connect_node(fNode, fPort, tNode, tPort)
	return

func on_disconnection_request(fNode: StringName, fPort: int, tNode: StringName, tPort: int) -> void:
	disconnect_node(fNode, fPort, tNode, tPort)
	return

func get_id_array() -> Array[int]:
	return _availableID

func set_id_array(idArray: Array[int]) -> void:
	_availableID = idArray
	return

func get_next_id() -> int:
	return _nextID

func set_next_id(nextID: int) -> void:
	_nextID = nextID
	return
