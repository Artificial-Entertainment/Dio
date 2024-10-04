extends GraphNode

var _closeButton: PackedScene = preload("res://components/graph_node/subscenes/close.tscn")
var _choice: PackedScene = preload("res://components/graph_node/subscenes/choice.tscn")
var _count: int = 0
const SLOT: int = 2 # because buttons are on slot 2

func _ready():
	var titleBar: HBoxContainer = get_titlebar_hbox()
	var closeButton: Button = _closeButton.instantiate()
	titleBar.add_child(closeButton)
	closeButton.connect("pressed", get_parent().on_close.bind(self))
	get_node("addRemoveButtons/add").connect("pressed", on_add)
	get_node("addRemoveButtons/remove").connect("pressed", on_remove)
	return

func on_add() -> void:
	_count += 1
	var choice: TextEdit = _choice.instantiate()
	choice.set_name("choice%d" % _count)
	add_child(choice)
	slots(true)
	return

func on_remove() -> void:
	if _count == 0:
		return
	get_node("choice%d" % _count).queue_free()
	slots(false)
	_count -= 1
	return

func slots(cond: bool) -> void:
	set_slot_enabled_left(_count + SLOT, cond)
	set_slot_enabled_right(_count + SLOT, cond)
	return
