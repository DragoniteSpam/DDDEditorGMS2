/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param tx
/// @param ty
/// @param text
/// @param halign
/// @param valign
/// @param color
/// @param interactive
/// @param onmouseup
/// @param UIThing

var x1 = argument0;
var y1 = argument1;
var x2 = argument2;
var y2 = argument3;
var tx = argument4;
var ty = argument5;
var text = argument6;
var halign = argument7;
var valign = argument8;
var color = argument9;
var enabled = argument10;
var onmouseup = argument11;
var thing = argument12;

if (enabled) {
    var c = c_white;
} else {
    var c = c_ltgray;
}

draw_rectangle_colour(x1, y1, x2, y2, c, c, c, c, false);
draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);

if (enabled) {
    if (mouse_within_rectangle(x1, y1, x2, y2)) {
        draw_rectangle_colour(x1, y1, x2, y2, c_ui, c_ui, c_ui, c_ui, false);
        if (get_release_left()) {
            script_execute(onmouseup, thing);
        } else if (Controller.press_help) {
            //ds_stuff_help_auto(thing);
        }
    }
}

draw_set_halign(halign);
draw_set_valign(valign);
draw_set_color(color);
draw_text_ext(tx, ty, string(text), -1, x2 - x1);