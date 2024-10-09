extends VBoxContainer

@export var _richLabel: RichTextLabel
var _currentNode: String = "node1" # all dialogues start from node1
var _dialogue: Dictionary = {}

func _ready() -> void:
	# asserts
	assert(_richLabel != null, "RichTextLabel is null")
	# grab _dialogue
	var graphState: GraphState = ResourceLoader.load("res://addons/dio/example/resource/example.res")
	_dialogue = graphState.get_dialogue()
	# signals
	for i in range(get_child_count()):
		var child: Button = get_child(i)
		child.pressed.connect(on_pressed.bind(child, i))
	show_dialogue(_currentNode)
	return

func show_dialogue(nodeId: String) -> void:
	_richLabel.set_text("")
	var node: Dictionary = _dialogue[nodeId]
	_richLabel.append_text("[b]%s[/b]\n" % node["name"])
	_richLabel.append_text("%s\n\n" % node["text"])
	show_options(node["choices"], node["connections"])
	return

func show_options(choices: PackedStringArray, connections: Array) -> void:
	var numChoices: int = choices.size()
	if numChoices == 0:
		if connections.size() > 0:
			show_button_options(["Continue"])
		else:
			show_button_options(["Exit"])
	else:
		show_button_options(choices)
	return

func show_button_options(options: Array) -> void:
	var buttons: Array[Node] = get_children()
	for i in range(options.size()):
		buttons[i].set_text(options[i])
		buttons[i].show()
	buttons[0].grab_focus()
	return

func hide_options() -> void:
	for child in get_children():
		child.set_text("")
		child.hide()
	return

func on_pressed(button: Button, i: int) -> void:
	var connections: Array = _dialogue[_currentNode]["connections"]
	hide_options()
	if connections.is_empty():
		get_tree().quit()
	else:
		_currentNode = connections[i]
		show_dialogue(_currentNode)
	return
