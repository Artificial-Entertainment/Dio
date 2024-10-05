extends GraphNode

var _choice: PackedScene = preload("res://components/node/subscenes/choice.tscn")
var _count: int = -1
var _id: int = 0

const SLOT: int = 3 # because buttons are on slot 3

func _ready():
	get_node("addRemoveButtons/add").connect("pressed", on_add)
	get_node("addRemoveButtons/remove").connect("pressed", on_remove)
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
	get_node("choice%d" % _count).queue_free()
	set_slot_enabled_right(_count + SLOT, false)
	_count -= 1
	return

func set_id(id: int) -> void:
	_id = id
	return

func get_id() -> int:
	return _id
