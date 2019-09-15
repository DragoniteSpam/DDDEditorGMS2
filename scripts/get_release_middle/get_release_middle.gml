/// @param [clear?]

var clear = (argument_count > 0) ? argument[0] : false;

var s = Controller.release_middle;
if (clear) Controller.release_middle = false;

return s;