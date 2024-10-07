@tool
extends GraphNode

@export var _remove_button: Button
@export var _add_button: Button

const CLOSE_BUTTON_SCENE: PackedScene = preload("res://addons/dialogue/node/subscenes/close.tscn")
const CHOICE_SCENE: PackedScene = preload("res://addons/dialogue/node/subscenes/choice.tscn")
const SLOT_OFFSET: int = 3  # Slot offset due to existing UI elements

var _choice_count: int = -1
var _id: int = 0

func _ready() -> void:
	_remove_button.pressed.connect(remove_choice)
	_add_button.pressed.connect(add_choice)
	add_close_button()
	return

func add_close_button() -> void:
	if get_parent() is GraphEdit:
		var close_button: Button = CLOSE_BUTTON_SCENE.instantiate()
		get_titlebar_hbox().add_child(close_button)
		close_button.pressed.connect(get_parent().on_delete.bind(self))
	return

func add_choice() -> void:
	_choice_count += 1
	var choice: TextEdit = CHOICE_SCENE.instantiate()
	choice.name = "choice%d" % _choice_count
	add_child(choice)
	set_slot_enabled_right(_choice_count + SLOT_OFFSET, true)
	return

func remove_choice() -> void:
	if _choice_count == -1:
		return
	var choice = get_node("choice%d" % _choice_count)
	remove_child(choice)
	choice.queue_free()
	set_slot_enabled_right(_choice_count + SLOT_OFFSET, false)
	_choice_count -= 1
	return

func set_id(new_id: int) -> void:
	_id = new_id
	return

func get_id() -> int:
	return _id
