/// @param MenuMain
/// @param x
/// @param y

var menu = argument0;
var xx = argument1;
var yy = argument2;

draw_set_color(c_white);
draw_rectangle(0, 0, xx + room_width, yy + menu.element_height, false);
draw_set_color(c_black);
draw_set_font(FDefault12);
draw_set_valign(fa_middle);

var active_rendered = false;

for (var i = 0; i < ds_list_size(menu.contents); i++) {
    var thing = menu.contents[| i];
    if (thing.enabled) {
        active_rendered = active_rendered || script_execute(thing.render, thing, xx + menu.element_width * i, yy);
    }
}

draw_line_colour(0, yy + menu.element_height, xx + room_width, yy + menu.element_height, c_black, c_black);

var element = Camera.menu.active_element;
if (!active_rendered && element) {
	script_execute(element.render, element, element.x, element.y);
}