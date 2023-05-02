class_name InputFilter extends Reference
# Can be used like Input but ignores unwantet input events.
# This allows easy management for many players in local mp.
#
# How it works:
# the InputFilter somewhat a replacement for Input
# get_axis() and simmilar functions will ignore inputs for other players but
# all buttons can still be in general actions like left/right
# That is because the InputFilter ignores the inputs that aren't on the right device
# and not in the right control scheme
#
# all events will be filtered by device so one action can be used 



# filters devices easily
export var devide_id := -1
# prevents mix ups with multiple schemes per controler
export var input_group := "scheme_0"

var _buffer := {}
var _just_pressed := []
var _just_released := []
var _just_pressed_buffer := []
var _just_released_buffer := []


func _init(device := devide_id, group := input_group):
	devide_id = device
	input_group = group


func flush():
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
	if !input_group.empty():
		if !event.is_action(input_group):
			return false
	return true


# write an event into the buffers. !THIS DOESN'T FILTER! Use parse_input() for filter functionality
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
func get_axis(negative_action: String, positive_action: String) -> float:
	return _buffer.get(positive_action, 0) - _buffer.get(negative_action, 0)


func is_action_just_released(action: String):
	return _just_released.has(action)

func is_action_just_pressed(action: String):
	return _just_pressed.has(action)

func is_action_pressed(action: String):
	return _buffer.get(action, 0) > .49


# QOL functions
func is_equal(to:InputFilter) -> bool:
	if is_instance_valid(to):
		return devide_id == to.devide_id and input_group == to.input_group
	return false

# for serialization
func _to_string():
	return "[InputFilter %s devide_id=%s input_group=%s]" % [
		get_instance_id(), devide_id, input_group
	]

static func from_string(string:String) -> InputFilter:
	assert(string.match("[InputFilter * devide_id=* input_group=*]"))
	var split := string.trim_prefix("[").trim_suffix("]").split(" ")
	var device := int(split[2].trim_prefix("devide_id="))
	var group := split[3].trim_prefix("input_group=")
	return load("res://addons/InputFilter/input_filter.gd").new(device, group)

