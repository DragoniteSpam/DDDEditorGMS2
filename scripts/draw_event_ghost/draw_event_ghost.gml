/// @description  void draw_event_ghost(x, y, x2, y2, outbound);
/// @param x
/// @param  y
/// @param  x2
/// @param  y2
/// @param  outbound

var x1=argument2;
var y1=argument3-12;
var x2=x1+EVENT_NODE_CONTACT_WIDTH;
var y2=argument3+12;
var padding=4;

draw_roundrect_colour(x1, y1, x2, y2, c_ev_ghost, c_ev_ghost, false);
draw_roundrect(x1, y1, x2, y2, true);

var c=colour_mute(c_ev_ghost);
if (mouse_within_rectangle_view(x1, y1, x2, y2)){
    draw_rectangle_colour(x1+padding, y1+padding, x2-padding, y2-padding, c, c, c, c, false);
    if (!dialog_exists()){
        if (get_release_left()){
            event_view_node(argument4);
        }
    }
}

draw_text(x1+16, argument3, string(argument4.name));
draw_line(argument0, argument1, argument2, argument3);
