/// @param UIText
/// @param y1
/// @param y2

var text = argument0;
var y1 = argument1;
var y2 = argument2;

var offset = 12;

switch (text.valignment) {
    case fa_top: return y1 + offset;
    case fa_middle: return mean(y1, y2);
    case fa_bottom: return y2 - offset;
}