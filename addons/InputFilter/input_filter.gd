class_name InputFilter extends Reference
# How it works:
# the InputFilter is a replacement for Input
# get_axis() and simmilar functions will ignore inputs for other players but
# all buttons can still be in general actions like left/right
# That is because the InputFilter ignores the inputs that aren't on the right device
# and not in the right control scheme
#
# all events will be filtered by device so one action can be used 



# filters devices easily
export var devide_id := -1
# prevents a mixups when more than 1 scheme is on the same controler
export var input_group := "scheme_0"

var _buffer := {}
var _just_pressed := []
var _just_released := []
var _just_pressed_buffer := []
var _just_released_buffer := []


func _init(tree:SceneTree, device:= devide_id, group:=input_group):
	devide_id = device
	input_group = group
	tree.connect("idle_frame", self, "_on_idle_frame")

func _on_idle_frame():
	_just_pressed = _just_pressed_buffer
	_just_released = _just_released_buffer
	_just_pressed_buffer = []
	_just_released_buffer = []

func parse_input(event: InputEvent):
	if is_event_caught(event):
		_parse_event(event)


func is_event_caught(event: InputEvent)->bool:
	if devide_id > 0 and event.device != devide_id:
		return false
	if !event.is_action(input_group):
		return false
	return true


func _parse_event(event: InputEvent):
	for action in InputMap.get_actions():
		if action is String:
			if event.is_action(action):
				var strenght := event.get_action_strength(action)
				if InputMap.action_get_deadzone(action) > strenght:
					_buffer.erase(action)
					_just_released_buffer.push_back(action)
				else:
					if !_buffer.has(action):
						_just_pressed_buffer.push_back(action)
					_buffer[action] = strenght



# emulated Input functions
func get_axis(negative_action: String, positive_action: String):
	return _buffer.get(positive_action, 0) - _buffer.get(negative_action, 0)


func is_action_just_released(action:String):
	return _just_released.has(action)

func is_action_just_pressed(action:String):
	return _just_pressed.has(action)

func is_action_pressed(action:String):
	return _buffer.get(action, 0) > .49

