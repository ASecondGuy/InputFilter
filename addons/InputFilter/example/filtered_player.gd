extends Node2D

var _input_filter := InputFilter.new(-1, "")


func _process(delta):
	_input_filter.flush()
	var move := _input_filter.get_vector("move_left", "move_right", "move_up", "move_down")
	
	position += move.normalized()*delta*100


func _input(event):
	_input_filter.parse_input(event)

func set_filter(filter: InputFilter):
	_input_filter = filter
