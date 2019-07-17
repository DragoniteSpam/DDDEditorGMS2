/// @param [clear?]
/// @param [override?]

var clear = (argument_count > 0) ? argument[0] : true;
var override = (argument_count > 1) ? argument[1] : false;

var s = Controller.release_escape;
if (clear) Controller.release_escape = false;

if (override) {
    Controller.escape = false;
    Controller.press_escape = false;
    Controller.release_escape = false;
}

return s;