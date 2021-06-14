/// @param x
/// @param y
/// @param node
function draw_event_node_choice_add(argument0, argument1, argument2) {

    var xx = argument0;
    var yy = argument1;
    var node = argument2;

    draw_sprite(spr_plus_minus, 0, xx, yy);

    var tolerance = 8;
    if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
        draw_sprite(spr_plus_minus, 1, xx, yy);
        draw_tooltip(xx, yy + 16, "Add Option");
        if (Controller.release_left) {
            array_push(node.data, "Option " + string(array_length(node.data)));
            // insert at the second to last position so that the "default" outbound node stays where it is
            array_insert(node.outbound, array_length(node.outbound) - 1, undefined);
        }
    }


}
