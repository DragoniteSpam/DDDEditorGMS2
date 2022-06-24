/// @param x
/// @param y
/// @param DataEventNode
function draw_event_node_custom_info(argument0, argument1, argument2) {

    var xx = argument0;
    var yy = argument1;
    var node = argument2;

    draw_sprite(spr_event_info, 0, xx, yy);

    if (!dialog_exists()) {
        var tolerance = 12;
        if (mouse_within_rectangle(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
            draw_sprite(spr_event_info, 1, xx, yy);
            Stuff.event.node_info = node;
            // No need to show tooltip because of the effect of mousing over this becomes
            // obvious immediately
        }
    }


}
