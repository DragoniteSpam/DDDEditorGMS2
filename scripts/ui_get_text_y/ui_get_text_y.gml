/// @description double ui_get_text_y(UIText, y1, y2);
/// @param UIText
/// @param y1
/// @param y2

var offset=12;

switch (argument0.valignment) {
    case fa_top:
        return argument1+offset;
    case fa_middle:
        return mean(argument1, argument2);
    case fa_bottom:
        return argument2-offset;
}
