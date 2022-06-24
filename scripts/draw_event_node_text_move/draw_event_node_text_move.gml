/// @param x
/// @param y
/// @param node
/// @param index
/// @param direction
/// @param image-index
function draw_event_node_text_move(argument0, argument1, argument2, argument3, argument4, argument5) {

    var xx = argument0;
    var yy = argument1;
    var node = argument2;
    var index = argument3;
    var dir = argument4;
    var i_index = argument5;

    draw_sprite(spr_scroll_arrow_enclosed, i_index, xx, yy);

    var tolerance = 8;
    if (mouse_within_rectangle(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
        draw_sprite(spr_scroll_arrow_enclosed, i_index + 1, xx, yy);
        draw_tooltip(xx, yy + 16, (!i_index) ? "Move Up" : "Move Down");
        if (Controller.release_left) {
            // no need to shuffle the outbound things, in this case
            var t = node.data[index + dir];
            node.data[index + dir] = node.data[index];
            node.data[index] = t;
        }
    }


}
