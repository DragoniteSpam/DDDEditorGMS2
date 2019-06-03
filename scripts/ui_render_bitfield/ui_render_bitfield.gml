/// @description void ui_render_bitfield(Button, x, y);
/// @param Button
/// @param x
/// @param y

/*
 * this is horizontal and the buttons are in line with the text. if you end up needing this
 * to be vertical or not in line, you probably want to add customization to this instead of
 * subclassing it
 *
 * ----------------------
 * |text    |01|02|03|04|
 * ----------------------
 */

ui_render_text(argument0, argument1, argument2);

draw_set_halign(fa_center);
// default valign is middle

for (var i=0; i<ds_list_size(argument0.contents); i++) {
    var thing=argument0.contents[| i];
    // these are all part of the same UIThing so there's no point in turning them
    // off
    script_execute(thing.render, thing, argument0.x+argument1, argument0.y+argument2); 
}

draw_set_halign(fa_left);
