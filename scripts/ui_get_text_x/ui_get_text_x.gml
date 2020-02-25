/// @param UIText
/// @param x1
/// @param x2
/// @param [alignment]

var text = argument[0];
var x1 = argument[1];
var x2 = argument[2];
var alignment = (argument_count > 3) ? argument[3] : text.alignment;

var offset = 12;

switch (alignment) {
    case fa_left: return x1 + offset;
    case fa_center: return floor(mean(x1, x2));
    case fa_right: return x2 - offset;
}