/// @description  boolean get_press_right([clear?]);
/// @param [clear?]

var clear=true;
switch (argument_count){
    case 1:
        clear=argument[0];
}

var s=Controller.press_right;
if (clear){
    Controller.press_right=false;
}
return s;
