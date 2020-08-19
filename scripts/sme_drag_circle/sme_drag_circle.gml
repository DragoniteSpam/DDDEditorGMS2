/// @param Selection
/// @param x
/// @param y
function sme_drag_circle(argument0, argument1, argument2) {

    var selection = argument0;
    var xx = argument1;
    var yy = argument2;

    selection.radius = floor(point_distance(selection.x, selection.y, xx, yy));


}
