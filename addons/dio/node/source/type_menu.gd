@tool
extends MenuButton

var _popup: PopupMenu = get_popup()
var _prevIndex: int = 0

func _ready() -> void:
	_popup.id_pressed.connect(on_pressed)
	return

func on_pressed(index: int) -> void:
	if index == _prevIndex:
		return
	set_text(_popup.get_item_text(index))
	_popup.set_item_checked(index, true)
	_popup.set_item_checked(_prevIndex, false)
	_prevIndex = index
	return
