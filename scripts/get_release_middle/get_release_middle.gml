/// @description boolean get_release_middle();

var clear=true;
switch (argument_count) {
    case 1:
        clear=argument[0];
}

var s=Controller.release_middle;
if (clear) {
    Controller.release_middle=false;
}
return s;
