/// @param UIBitfield
/// @param x
/// @param y
function ui_render_bitfield(argument0, argument1, argument2) {

    var bitfield = argument0;
    var xx = argument1;
    var yy = argument2;

    /*
     * this is horizontal and the buttons are in line with the text. if you end up needing this
     * to be vertical or not in line, you probably want to add customization to this instead of
     * subclassing it
     *
     * ----------------------
     * |text    |01|02|03|04|
     * ----------------------
     */

    ui_render_text(bitfield, xx, yy);

    draw_set_halign(fa_center);
    // default valign is middle

    for (var i = 0; i < ds_list_size(bitfield.contents); i++) {
        var thing = bitfield.contents[| i];
        //ui_activate(bitfield);
        // these are all part of the same UIThing so there's no point in turning them off
        script_execute(thing.render, thing, bitfield.x + xx, bitfield.y + yy); 
    }

    draw_set_halign(fa_left);

    ui_handle_dropped_files(bitfield);


}
