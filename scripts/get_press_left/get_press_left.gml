/// @description  boolean get_press_left([clear?]);
/// @param [clear?]

var clear=true;
switch (argument_count){
    case 1:
        clear=argument[0];
}

var s=Controller.press_left;
if (clear){
    Controller.press_left=false;
}
return s;
