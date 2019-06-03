/// @description boolean get_release_escape([clear?], [override?]);
/// @param [clear?]
/// @param [override?]

var clear=true;
var override=false;
switch (argument_count) {
    case 2:
        override=argument[1];
    case 1:
        clear=argument[0];
}

var s=Controller.release_escape;
if (clear) {
    Controller.release_escape=false;
}

if (override) {
    Controller.escape=false;
    Controller.press_escape=false;
    Controller.release_escape=false;
}

return s;
