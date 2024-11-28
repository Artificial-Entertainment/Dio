@tool
extends GraphEdit

const LOAD_GRAPH_BUTTON: PackedScene = preload("res://addons/dio/graph/subscenes/load_graph.tscn")
const SAVE_GRAPH_BUTTON: PackedScene = preload("res://addons/dio/graph/subscenes/save_graph.tscn")
const ADD_NODE_BUTTON: PackedScene = preload("res://addons/dio/graph/subscenes/add_node.tscn")
const V_SEP: PackedScene = preload("res://addons/dio/graph/subscenes/vsep.tscn")
const GRAPH_NODE: PackedScene = preload("res://addons/dio/node/graph_node.tscn")
const GRAPH_NODE_SIZE_Y: float = 200.0 # rought estimate, but mostly true
@export var _fileDialog: FileDialog

var _availableID: Array[int] = []
var _currentID: int = 0

func _ready() -> void:
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
	saveBtn.pressed.connect(on_save)
	loadBtn.pressed.connect(on_load)
	# Connect graph signals
	disconnection_request.connect(on_disconnection)
	connection_request.connect(on_connection)
	delete_nodes_request.connect(on_delete)
	connection_to_empty.connect(on_empty)
	# Based on doc recommendations
	OS.set_low_processor_usage_mode(true)
	return


# Drag and drop GraphState
func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("files")

func _drop_data(_pos: Vector2, data: Variant) -> void:
	if data.files.size() > 0:
		_fileDialog.load_file(data.files[0])
	return

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
	var n: Array[StringName] = [StringName(nodeName)]
	var closeButton: Button = dialogueNode.get_close_button()
	closeButton.pressed.connect(on_delete.bind(n))
	return

# Disconnect choice before removing it, prevent null pointer
func on_choice_removed(node: GraphNode, port: int) -> void:
	var connections: Array[Dictionary] = get_connection_list()
	for conn in connections:
		if conn["from_node"] == node.get_name() and conn["from_port"] == port:
			disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
	return

func on_add() -> void:
	var id: int = get_valid_id()
	var pos: Vector2 = Vector2.ONE * (id % 10 + 1) * 10
	add_graph_node(id, "node%d" % id, "Response Text", [], pos)
	return

func on_empty(fNode: StringName, fPort: int, pos: Vector2) -> void:
	var id: int = get_valid_id()
	var nodeSize: Vector2 = Vector2.UP * GRAPH_NODE_SIZE_Y / 2.0
	pos += get_scroll_offset() + nodeSize
	add_graph_node(id, "node%d" % id, "Response Text", [], pos)
	connect_node(fNode, fPort, "node%d" % id, 0)
	return

func on_delete(nodes: Array[StringName]):
	for n in nodes:
		var dialogueNode: GraphNode = get_node(NodePath(n))
		var nodeID: int = dialogueNode.get_id()
		if _currentID != nodeID:
			_availableID.append(nodeID)
		else:
			_currentID -= 1
		dialogueNode.queue_free()
	return

func on_connection(fNode: StringName, fPort: int, tNode: StringName, tPort: int) -> void:
	connect_node(fNode, fPort, tNode, tPort)
	return

func on_disconnection(fNode: StringName, fPort: int, tNode: StringName, tPort: int) -> void:
	disconnect_node(fNode, fPort, tNode, tPort)
	return

func external_save() -> void:
	_fileDialog.save_preset()
	_fileDialog.autosave()
	return

func on_save() -> void:
	_fileDialog.save_preset()
	_fileDialog.popup_centered_ratio(0.65)
	return

func on_load() -> void:
	_fileDialog.load_preset()
	_fileDialog.popup_centered_ratio(0.65)
	return

func get_id_array() -> Array[int]:
	return _availableID

func set_id_array(idArray: Array[int]) -> void:
	_availableID = idArray
	return

func get_valid_id() -> int:
	if _availableID.size() > 0:
		return _availableID.pop_front()
	else:
		_currentID += 1
		return _currentID

func get_current_id() -> int:
	return _currentID

func set_current_id(currentID: int) -> void:
	_currentID = currentID
	return
