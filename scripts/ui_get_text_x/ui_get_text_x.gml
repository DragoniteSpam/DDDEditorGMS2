/// @description  double ui_get_text_x(UIText, x1, x2);
/// @param UIText
/// @param  x1
/// @param  x2

var offset=12;

switch (argument0.alignment){
    case fa_left:
        return argument1+offset;
    case fa_center:
        return mean(argument1, argument2);
    case fa_right:
        return argument2-offset;
}
