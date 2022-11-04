# InputFilter
The InputFilter makes it easy to distinguisch inputs from different controlers and even multiple control schemes on the same controler.

## Setup:
1. Get a InputFilter Resource (either load it or use `InputFilter.new()`)
2. Add these functions (or the content at the start if you already use them)
   ```py
    func _input(event):
        # The filter will only consider events that get parsed like this.
        # Not parsing events can be an easy way to lock all input temporarily.
        _input_filter.parse_input(event)

        # if you want to use events directly you can use this to filter manually
        if _input_filter.is_event_caught(event):
            pass

    func _process(_delta):
        # tells the filter when to update just_pressed and just_released.
        # this isn't needed if you don't use those.
        _input_filter.flush()
   ```
3.  Configure the Input actions.  
   Use general actions like "walk_left" and fill them with all buttons that should trigger the action.  
   Then put all buttons in a group (ex. WASD in "scheme_0" and the arrow buttons into "scheme_1"). If you use the device filter you can even reuse those groups for the controler schemes (ex. WASD & left joystick)
4. Make sure you use the correct InputFilters and have them configured with the right scheme group and device id (or "" and -1 to disable thse filter options).

