/// @param [clear?]

var clear = (argument_count > 0) ? argument[0] : true;

var s = Controller.release_right;
if (clear) Controller.release_right = false;

return s;