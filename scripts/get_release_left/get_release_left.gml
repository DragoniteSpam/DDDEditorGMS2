/// @description  boolean get_release_left([clear?]);
/// @param [clear?]

var clear=true;
switch (argument_count){
    case 1:
        clear=argument[0];
}

var s=Controller.release_left;
if (clear){
    Controller.release_left=false;
}
return s;
