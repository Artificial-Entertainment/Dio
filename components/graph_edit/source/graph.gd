extends GraphEdit

var _addNodeButton: PackedScene = preload("res://components/graph_edit/subscenes/add_node.tscn")
var _closeNodeButton: PackedScene = preload("res://components/graph_node/subscenes/close.tscn")
var _graphNode: PackedScene = preload("res://components/graph_node/graph_node.tscn")
var _vSep: PackedScene = preload("res://components/graph_edit/subscenes/vsep.tscn")
var _count: int = 1

func _ready() -> void:
	var menu: HBoxContainer = get_menu_hbox()
	var btn: Button = _addNodeButton.instantiate()
	var vsep: VSeparator = _vSep.instantiate()
	for node in [vsep, btn]:
		menu.add_child(node)
		menu.move_child(node, 0)
	btn.connect("pressed", on_add)
	connect("connection_request", on_connection_request)
	connect("disconnection_request", on_disconnection_request)
	return

func on_add() -> void:
	var dialogueNode: GraphNode = _graphNode.instantiate()
	var nodeName: String = "node%d" % _count 
	dialogueNode.set_name(nodeName)
	dialogueNode.set_title(nodeName)
	_count += 1
	add_child(dialogueNode)
	var pos: Vector2 = dialogueNode.get_position_offset()
	dialogueNode.set_position_offset(Vector2(pos.x + _count * 250, pos.y))
	var closeButton: Button = _closeNodeButton.instantiate()
	dialogueNode.get_titlebar_hbox().add_child(closeButton)
	closeButton.connect("pressed", on_close.bind(dialogueNode))
	return

# connected to child dialogue nodes
func on_close(dialogueNode: GraphNode) -> void:
	_count -= 1
	dialogueNode.queue_free()
	return

func on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)
	return

func on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)
	return
