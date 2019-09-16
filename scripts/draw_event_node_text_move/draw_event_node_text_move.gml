/// @param x
/// @param y
/// @param node
/// @param index
/// @param direction
/// @param image-index

var xx = argument0;
var yy = argument1;
var node = argument2;
var index = argument3;
var dir = argument4;
var i_index = argument5;

draw_sprite(spr_scroll_arrow_enclosed, i_index, xx, yy);

var tolerance = 8;
if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
    draw_sprite(spr_scroll_arrow_enclosed, index + 1, xx, yy);
    if (Controller.release_left) {
        // no need to shuffle the outbound things, in this case
        var t = node.data[| index + dir];
        node.data[| index + dir] = node.data[| index];
        node.data[| index] = t;
    }
}