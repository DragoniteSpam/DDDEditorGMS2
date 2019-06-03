/// @description void ui_render_bitfield_option(UIBitFieldOption, x, y);
/// @param UIBitFieldOption
/// @param x
/// @param y

var x1=argument0.x+argument1;
var y1=argument0.y+argument2;
var x2=x1+argument0.width;
var y2=y1+argument0.height;

if (argument0.state) {
    draw_rectangle_colour(x1, y1, x2, y2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
}

// not entirely sure what the deal with this is, normally I can draw rectangle outlines
// without worrying about whether the edges are off by a pixel or not. whatever.
draw_rectangle_colour(x1+1, y1+1, x2-1, y2-1, c_black, c_black, c_black, c_black, true);

if (argument0.interactive&&dialog_is_active(argument0.root)) {
    if (mouse_within_rectangle(x1, y1, x2, y2)) {
        if (get_release_left()) {
            script_execute(argument0.onvaluechange, argument0);
        } else if (Controller.press_help) {
            //ds_stuff_help_auto(argument0);
        }
    }
}
