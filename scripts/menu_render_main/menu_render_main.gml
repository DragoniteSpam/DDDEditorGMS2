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

menu.mouse_over = noone;

for (var i = 0; i < ds_list_size(menu.contents); i++) {
    var thing = menu.contents[| i];
    if (thing.enabled) {
        script_execute(thing.render, thing, xx + menu.element_width * i, yy);
    }
}

draw_line_colour(0, yy + menu.element_height, xx + room_width, yy + menu.element_height, c_black, c_black);

var element = Camera.menu.extra_element;
if (element) {
	script_execute(element.render, element, element.x, element.y);
}

if ((!dialog_exists() && !mouse_within_rectangle_view(0, 0, xx + room_width, yy + menu.element_height))) {
	if (!menu.mouse_over && (Controller.press_left || Controller.press_right)) {
		menu_activate(noone);
	}
}

// if the cursor is in the menu bar just disable clicking, because it'll be more
// trouble than it's worth
if (mouse_within_rectangle_view(0, 0, xx + room_width, yy + menu.element_height)) {
	Controller.press_left = false;
	Controller.press_right = false;
}