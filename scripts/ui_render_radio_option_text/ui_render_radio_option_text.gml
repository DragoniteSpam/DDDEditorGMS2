/// @param Button
/// @param x
/// @param y

var x1 = argument0.x + argument1;
var y1 = argument0.y + argument2;
var x2 = x1 + argument0.width;
var y2 = y1 + argument0.height;

var tx = ui_get_text_x(argument0, x1, x2);
var ty = ui_get_text_y(argument0, y1, y2);

var enabled = argument0.root.interactive && argument0.interactive;

// this is not quite the same as ui_render_text
draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
var c = enabled ? argument0.color : c_gray;
draw_text_colour(tx + 32, ty, string(argument0.text), c, c, c, c, 1);

var router = 8;
var rinner = 4;

if (!enabled) {
    draw_circle_colour(tx + 16, ty, router, c_ltgray, c_ltgray, false);
}
draw_circle(tx + 16, ty, router, true);

if (argument0.root.value == argument0.value) {
    if (!enabled) {
        draw_set_alpha(0.5);
    }
    draw_circle_colour(tx + 16, ty, rinner, c_green, c_green, false);
    draw_set_alpha(1);
}

// argument0.root is the radio array object that contains the element.
// argument0.root.root is the panel that it lives on.
if (enabled && dialog_is_active(argument0.root.root)) {
    if (mouse_within_rectangle(x1, y1, x2, y2)) {
        if (get_release_left()) {
            argument0.root.value = argument0.value;
            script_execute(argument0.root.onvaluechange, argument0);
        } else if (Controller.press_help) {
            //ds_stuff_help_auto(argument0);
        }
    }
}