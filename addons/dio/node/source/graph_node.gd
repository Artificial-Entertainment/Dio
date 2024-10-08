@tool
extends GraphNode

@export var _addButton: Button
@export var _removeButton: Button
@export var _textEdit: TextEdit

const CLOSE_BUTTON_SCENE: PackedScene = preload("res://addons/dio/node/subscenes/close.tscn")
const CHOICE_SCENE: PackedScene = preload("res://addons/dio/node/subscenes/choice.tscn")
const SLOT_OFFSET: int = 3  # Slot offset due to existing UI elements

var _choiceCount: int = -1
var _id: int = 0

func _ready() -> void:
	# assert exports
	if _textEdit == null:
		push_error("TextEdit is not set")
	if _addButton == null:
		push_error("AddButton is not set")
	if _removeButton == null:
		push_error("RemoveButton is not set")
	# adding/removing choices
	_addButton.pressed.connect(add_choice)
	_removeButton.pressed.connect(remove_choice)
	# adding 'X' button top right
	if get_parent() is GraphEdit:
		var close_button: Button = CLOSE_BUTTON_SCENE.instantiate()
		get_titlebar_hbox().add_child(close_button)
		close_button.pressed.connect(get_parent().on_delete.bind(self))
	return

func add_choice(text: String = "New Choice") -> void:
	_choiceCount += 1
	var choice: TextEdit = CHOICE_SCENE.instantiate()
	choice.name = "choice%d" % _choiceCount
	choice.set_text(text)
	add_child(choice)
	set_slot_enabled_right(_choiceCount + SLOT_OFFSET, true)
	return

func remove_choice() -> void:
	if _choiceCount == -1:
		return
	var choice = get_node("choice%d" % _choiceCount)
	remove_child(choice)
	choice.queue_free()
	set_slot_enabled_right(_choiceCount + SLOT_OFFSET, false)
	_choiceCount -= 1
	return

func get_id() -> int:
	return _id

func set_id(new_id: int) -> void:
	_id = new_id
	return

func get_text() -> String:
	return _textEdit.get_text()

func set_text(new_text: String) -> void:
	_textEdit.set_text(new_text)
	return

func get_choices() -> Array[String]:
	var choices: Array[String] = []
	for i in range(SLOT_OFFSET, get_child_count()):
		choices.append(get_child(i).get_text())
	return choices

func set_choices(new_choices: Array) -> void:
	for choice in new_choices:
		add_choice(choice)
	return
