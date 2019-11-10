/// @param UIProgressBar
/// @param x
/// @param y

var bar = argument0;
var xx = argument1;
var yy = argument2;

var padding = 16;
var base_x1 = xx + bar.x;
var base_y1 = yy + bar.y;
var base_x2 = base_x1 + bar.width;
var base_y2 = base_y1 + bar.height;

var x1 = base_x1 + padding;
var y1 = base_y1;
var x2 = base_x2 - padding;
var y2 = base_y2;

var mid_yy = mean(y1, y2);
var bar_y1 = mid_yy + bar.thickness / 2;
var bar_y2 = mid_yy - bar.thickness / 2;
var bar_x = x1 + clamp(bar.value, 0, 1) * (x2 - x1);

draw_rectangle_colour(x1, bar_y1, bar_x, bar_y2, bar.color, bar.color, bar.color, bar.color, false);
draw_rectangle_colour(x1, bar_y1, x2, bar_y2, c_black, c_black, c_black, c_black, true);

draw_sprite(spr_slider, 0, bar_x, mid_yy);

if (bar.interactive && dialog_is_active(bar.root)) {
    var inbounds = mouse_within_rectangle_determine(x1, y1, x2, y2, bar.adjust_view);
    
    if (inbounds) {
        if (Controller.press_left) {
            bar.clicked = true;
        }
        Stuff.element_tooltip = bar;
    }
    
    if (Controller.mouse_left && bar.clicked) {
        bar.value = clamp((mouse_x_view - x1) / (x2 - x1), 0, 1);
        ui_activate(bar);
        script_execute(bar.onvaluechange, bar);
    } else {
        bar.clicked = false;
    }
}