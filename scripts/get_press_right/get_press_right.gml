/// @param [clear?]

var clear = (argument_count > 0) ? argument[0] : true;

var s = Controller.press_right;
if (clear) Controller.press_right = false;

return s;