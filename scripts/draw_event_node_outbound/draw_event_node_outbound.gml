/// @param x
/// @param y
/// @param node
/// @param [index]
/// @param [terminal?]
function draw_event_node_outbound() {

    var xx = argument[0];
    var yy = argument[1];
    var node = argument[2];
    var index = (argument_count > 3) ? argument[3] : 0;
    var terminal = (argument_count > 4) ? argument[4] : false;

    draw_sprite(spr_event_outbound, terminal ? 0 : 1, xx, yy);

    var tolerance = 12;

    if (!dialog_exists()) {
        if (mouse_within_rectangle(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
            var custom = guid_get(node.custom_guid);
            if (custom) {
                var str = custom.outbound[index];
                if (string_length(str) > 0) {
                    draw_tooltip(floor(xx - 16 - string_width(str) / 2 - 4), floor(yy - string_height(str) / 2 - 4), str);
                }
            }
            if (Controller.press_left) {
                if (Controller.double_left) {
                    dialog_create_event_get_event_graph(noone, node, index);
                } else {
                    Stuff.event.canvas_active_node = node;
                    Stuff.event.canvas_active_node_index = index;
                }
            }
        }
    }


}
