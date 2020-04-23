/// @param UIText
/// @param x1
/// @param x2
/// @param [alignment]

var text = argument[0];
var y1 = argument[1];
var y2 = argument[2];
var alignment = (argument_count > 3) ? argument[3] : text.valignment;

switch (alignment) {
    case fa_top: return y1 + text.offset;
    case fa_middle: return floor(mean(y1, y2));
    case fa_bottom: return y2 - text.offset;
}