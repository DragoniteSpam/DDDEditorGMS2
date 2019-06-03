/// @description void ui_render_tab(UITab, x, y);
/// @param UITab
/// @param x
/// @param y
// this is for drawing the actual tab, not its contents. if you put
// the code to draw the contents in here and have more than one tab,
// everything is going to be layered on top of everything else.

var x1=argument0.x+argument1;
var y1=argument0.y-argument0.height/2+argument2;
var x2=x1+argument0.width;
var y2=y1+argument0.height;

if (!argument0.interactive) {
    draw_rectangle_colour(x1, y1, x2, y2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, true);
}

draw_line(x1, y1, x2, y1);
draw_line(x1, y1, x1, y2);
draw_line(x2, y1, x2, y2);
if (argument0.root.active_tab!=argument0) {
    draw_line(x1, y2, x2, y2);
}

var tx=ui_get_text_x(argument0, x1, x2);
var ty=ui_get_text_y(argument0, y1, y2);

draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
draw_set_color(argument0.color);
draw_text(tx, ty, string(argument0.text));

if (argument0.interactive&&dialog_is_active(argument0.root)) {
    if (mouse_within_rectangle(x1, y1, x2, y2)) {
        if (get_release_left()) {
            script_execute(argument0.onmouseup, argument0);
        } else if (Controller.press_help) {
            //ds_stuff_help_auto(argument0);
        }
    }
}
