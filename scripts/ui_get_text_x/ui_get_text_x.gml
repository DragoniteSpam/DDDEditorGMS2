/// @param UIText
/// @param x1
/// @param x2

var text = argument0;
var x1 = argument1;
var x2 = argument2;

var offset = 12;

switch (text.alignment) {
    case fa_left: return x1 + offset;
    case fa_center: return floor(mean(x1, x2));
    case fa_right: return x2 - offset;
}