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

// the background goes before everything, because you want to draw over it on hover
var c = enabled ? c_white : c_ltgray;
draw_rectangle_colour(x1, y1, x2, y2, c, c, c, c, false);

if (enabled) {
    var inbounds = mouse_within_rectangle_determine(x1, y1, x2, y2, thing.adjust_view);
    if (inbounds) {
        draw_rectangle_colour(x1, y1, x2, y2, c_ui, c_ui, c_ui, c_ui, false);
        if (Controller.release_left) {
            Controller.release_left = false;
            script_execute(onmouseup, thing);
        }
        Stuff.element_tooltip = thing;
    }
}

if (thing.outline) {
    draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);
}

draw_set_halign(halign);
draw_set_valign(valign);
draw_set_color(color);
draw_text_ext(tx, ty, string(text), -1, x2 - x1);