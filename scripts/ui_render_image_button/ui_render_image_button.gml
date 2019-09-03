/// @param UIImageButton
/// @param x
/// @param y

var button = argument0;
var xx = argument1;
var yy = argument2;

var x1 = button.x + xx;
var y1 = button.y + yy;
var x2 = x1 + button.width;
var y2 = y1 + button.height;

var tx = ui_get_text_x(button, x1, x2);
var ty = ui_get_text_y(button, y1, y2);

var c = button.interactive ? c_white : c_ltgray;

draw_rectangle_colour(x1, y1, x2, y2, c, c, c, c, false);

if (button.outline) {
    draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);
}

var color = c_white;
if (button.interactive && dialog_is_active(button.root)) {
    var inbounds = mouse_within_rectangle_determine(x1, y1, x2, y2);
    if (inbounds) {
        draw_rectangle_colour(x1, y1, x2, y2, c_ui, c_ui, c_ui, c_ui, false);
        color = merge_color(c_white, c_ui, 0.5);
        if (get_release_left()) {
            script_execute(button.onmouseup, button);
        }
    }
}

if (!button.image) {
    draw_set_halign(button.alignment);
    draw_set_valign(button.valignment);
    draw_set_color(button.color);
    draw_text_ext(tx, ty, string(button.text), -1, button.width);
} else {
    draw_sprite_general(button.image, button.index, 0, 0, min(button.width, sprite_get_width(button.image)),
        min(button.height, sprite_get_height(button.image)), x1, y1, 1, 1, 0, color, color, color, color, 1);
}