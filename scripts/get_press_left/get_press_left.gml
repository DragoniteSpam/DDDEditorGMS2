/// @param [clear?]

var clear = (argument_count > 0) ? argument[0] : false;

var s = Controller.press_left;
if (clear) Controller.press_left = false;

return s;