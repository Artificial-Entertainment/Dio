@tool
extends GraphNode

@export var _add: Button
@export var _rem: Button

var _closeNodeButton: PackedScene = preload("res://addons/dialogue/node/subscenes/close.tscn")
var _choice: PackedScene = preload("res://addons/dialogue/node/subscenes/choice.tscn")
var _count: int = -1
var _id: int = 0

const SLOT: int = 3 # because buttons are on slot 3

func _ready() -> void:
	_add.pressed.connect(on_add)
	_rem.pressed.connect(on_remove)
	# adding 'X' top right
	if get_parent() is GraphEdit:
		var closeButton: Button = _closeNodeButton.instantiate()
		get_titlebar_hbox().add_child(closeButton)
		closeButton.pressed.connect(get_parent().on_delete.bind(self))
	return

func on_add() -> void:
	_count += 1
	var choice: TextEdit = _choice.instantiate()
	choice.set_name("choice%d" % _count)
	add_child(choice)
	set_slot_enabled_right(_count + SLOT, true)
	return

func on_remove() -> void:
	if _count == -1:
		return
	var choice = get_node("choice%d" % _count)
	remove_child(choice)
	choice.queue_free()
	set_slot_enabled_right(_count + SLOT, false)
	_count -= 1
	return

func set_id(id: int) -> void:
	_id = id
	return

func get_id() -> int:
	return _id
