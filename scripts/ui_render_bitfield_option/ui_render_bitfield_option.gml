/// @param UIBitFieldOption
/// @param x
/// @param y
function ui_render_bitfield_option(argument0, argument1, argument2) {

    var bitfield = argument0;
    var xx = argument1;
    var yy = argument2;

    var x1 = bitfield.x + xx;
    var y1 = bitfield.y + yy;
    var x2 = x1 + bitfield.width;
    var y2 = y1 + bitfield.height;

    var c = bitfield.state ? bitfield.color_active : bitfield.color_inactive;
    draw_rectangle_colour(x1, y1, x2, y2, c, c, c, c, false);

    // not entirely sure what the deal with this is, normally I can draw rectangle outlines
    // without worrying about whether the edges are off by a pixel or not. whatever.
    draw_rectangle_colour(x1 + 1, y1 + 1, x2 - 1, y2 - 1, c_black, c_black, c_black, c_black, true);

    if (bitfield.interactive && dialog_is_active(bitfield.root.root)) {
        var inbounds = mouse_within_rectangle(x1, y1, x2, y2);
        if (inbounds) {
            if (Controller.release_left) {
                ui_activate(bitfield);
                bitfield.onvaluechange(bitfield);
            }
            Stuff.element_tooltip = bitfield.root;
        }
    }

    ui_handle_dropped_files(bitfield);


}
