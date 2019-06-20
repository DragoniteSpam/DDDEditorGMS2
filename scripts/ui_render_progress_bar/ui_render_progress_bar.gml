/// @param UIProgressBar
/// @param x
/// @param y

var padding = 16;
var base_x1 = argument1 + argument0.x;
var base_y1 = argument2 + argument0.y;
var base_x2 = base_x1 + argument0.width;
var base_y2 = base_y1 + argument0.height;

var x1 = base_x1 + padding;
var y1 = base_y1;
var x2 = base_x2 - padding;
var y2 = base_y2;

var mid_yy = mean(y1, y2);
var bar_y1 = mid_yy + argument0.thickness / 2;
var bar_y2 = mid_yy - argument0.thickness / 2;
var bar_x = x1 + clamp(argument0.value, 0, 1) * (x2 - x1);

draw_rectangle_colour(x1, bar_y1, bar_x, bar_y2, argument0.color, argument0.color, argument0.color, argument0.color, false);
draw_rectangle_colour(x1, bar_y1, x2, bar_y2, c_black, c_black, c_black, c_black, true);

draw_sprite(spr_slider, 0, bar_x, mid_yy);

if (argument0.interactive && mouse_within_rectangle(x1, y1, x2, y2) && dialog_is_active(argument0.root)) {
    if (Controller.mouse_left) {
        argument0.value = (Camera.MOUSE_X - x1) / (x2 - x1);
        script_execute(argument0.onvaluechange, argument0);
    }
}