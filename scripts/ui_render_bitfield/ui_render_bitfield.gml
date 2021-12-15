function ui_render_bitfield(bitfield, x, y) {
    /*
     * this is horizontal and the buttons are in line with the text. if you end up needing this
     * to be vertical or not in line, you probably want to add customization to this instead of
     * subclassing it
     *
     * ----------------------
     * |text    |01|02|03|04|
     * ----------------------
     */

    ui_render_text(bitfield, x, y);

    draw_set_halign(fa_center);
    // default valign is middle

    for (var i = 0; i < ds_list_size(bitfield.contents); i++) {
        var thing = bitfield.contents[| i];
        // these are all part of the same UIThing so there's no point in turning them off
        if (is_struct(thing)) {
            thing.Render(bitfield.x + x, bitfield.y + y); 
        } else {
            thing.render(thing, bitfield.x + x, bitfield.y + y); 
        }
    }

    draw_set_halign(fa_left);

    ui_handle_dropped_files(bitfield);
}