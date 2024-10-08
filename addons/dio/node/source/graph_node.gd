@tool
extends GraphNode

signal choice_removed(node: GraphNode, port: int)

@export var _addButton: Button
@export var _textEdit: TextEdit
@export var _removeButton: Button

const CLOSE_BUTTON_SCENE: PackedScene = preload("res://addons/dio/node/subscenes/close.tscn")
const CHOICE_SCENE: PackedScene = preload("res://addons/dio/node/subscenes/choice.tscn")
const SLOT_OFFSET: int = 3  # Slot offset due to existing UI elements

var _choiceCount: int = -1
var _id: int = 0

func _ready() -> void:
	# assert exports
	assert(_textEdit != null, "TextEdit is not set")
	assert(_addButton != null, "AddButton is not set")
	assert(_removeButton != null, "RemoveButton is not set")
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
	choice_removed.emit(self, _choiceCount)
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

func get_choices() -> PackedStringArray:
	var choices: PackedStringArray = []
	for i in range(SLOT_OFFSET, get_child_count()):
		var text = get_child(i).get_text()
		choices.append(text)
	return choices

func set_choices(new_choices: PackedStringArray) -> void:
	for choice in new_choices:
		add_choice(choice)
	return