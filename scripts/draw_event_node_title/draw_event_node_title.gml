/// @param DataEventNode
/// @param color
function draw_event_node_title(argument0, argument1) {

    var node = argument0;
    var color = argument1;
    var x1 = node.x;
    var y1 = node.y;
    var x2 = node.x + EVENT_NODE_CONTACT_WIDTH;
    var y2 = node.y + EVENT_NODE_CONTACT_HEIGHT;
    var tolerance = 8;

    if (!dialog_exists() && !Stuff.event.canvas_active_node) {
        if (mouse_within_rectangle(x1 + tolerance, y1 + tolerance, x2 - tolerance, y2 - tolerance)) {
            draw_rectangle_colour(x1 + tolerance, y1 + tolerance, x2 - tolerance, y2 - tolerance, color, color, color, color, false);
        
            // i don't like this either but it also works (for now)
            if (Controller.release_left && !Stuff.event.canvas_active_node) {
                dialog_create_event_node_rename(node);
            }
        }
    }

    draw_text(x1 + 16, mean(y1, y2), string(node.name));


}
