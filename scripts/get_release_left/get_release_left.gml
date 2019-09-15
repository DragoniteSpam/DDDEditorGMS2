/// @param [clear?]

var clear = (argument_count > 0) ? argument[0] : true;

var s = Controller.release_left;
if (clear) Controller.release_left = false;

return s;