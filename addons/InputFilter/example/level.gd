extends Node2D

var _filters := []

func _input(event):
	if !event.is_pressed():
		return
	
	# skip event if another filter already handles it
	for f in _filters:
		if f.is_event_caught(event):
			return
	
	# test what scheme it belongs to (0-9)
	for i in range(10):
		var scheme := "scheme_%s" % i
		
		# skip non existent schemes
		if !InputMap.has_action(scheme):
			continue
		
		if !event.is_action(scheme):
			continue
		
		# event is in scheme
		#spawn a new player and break
		_new_player(scheme, event.device)
		break


func _new_player(scheme: String, device: int):
	var filter := InputFilter.new(device, scheme)
	_filters.push_back(filter)
	var player := preload("res://addons/InputFilter/example/filtered_player.tscn").instantiate()
	player.set_filter(filter)
	add_child(player)
	player.position = get_window().size/2
