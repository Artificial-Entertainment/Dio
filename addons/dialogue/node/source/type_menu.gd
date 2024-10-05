@tool
extends MenuButton

var _popup: PopupMenu = get_popup()
var _prevIdx: int = 0

func _ready() -> void:
	_popup.connect("id_pressed", on_pressed)
	return

func on_pressed(idx: int) -> void:
	if idx == _prevIdx:
		return
	set_text(_popup.get_item_text(idx))
	_popup.set_item_checked(idx, true)
	_popup.set_item_checked(_prevIdx, false)
	_prevIdx = idx
	return
