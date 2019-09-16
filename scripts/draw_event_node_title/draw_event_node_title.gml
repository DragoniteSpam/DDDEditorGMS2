/// @param DataEventNode
/// @param color

var node = argument0;
var color = argument1;
var x1 = node.x;
var y1 = node.y;
var x2 = node.x + EVENT_NODE_CONTACT_WIDTH;
var y2 = node.y + EVENT_NODE_CONTACT_HEIGHT;
var tolerance = 4;

if (!dialog_exists() && !event_canvas_active_node) {
    if (mouse_within_rectangle_adjusted(x1, y1, x2, y2)) {
        draw_rectangle_colour(x1 + tolerance, y1 + tolerance, x2 - tolerance, y2 - tolerance, color, color, color, color, false);
        
        // i don't like this either but it also works
        if (Controller.release_left) {
            var new_name = get_string("New name for this node?", node.name);
            if (new_name != node.name) {
                if (string_length(new_name) == 0) {
                    // don't
                } else if (ds_map_exists(node.event.name_map, new_name)) {
                    show_message(new_name + " is already in use!");
                } else {
                    ds_map_delete(node.event.name_map, node.name);
                    ds_map_add(node.event.name_map, new_name, node);
                    node.name = new_name;
                }
            }
        }
    }
}
    
draw_text(x1 + 16, mean(y1, y2), string(node.name));