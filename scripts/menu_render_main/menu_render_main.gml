/// @param MenuMain
/// @param x
/// @param y

var xx = argument1;
var yy = argument2;

draw_set_color(c_white);
draw_rectangle(0, 0, xx + room_width, yy + argument0.element_height, false);
draw_set_color(c_black);
draw_set_font(FDefault12);
draw_set_valign(fa_middle);

for (var i = 0; i < ds_list_size(argument0.contents); i++) {
    var thing = argument0.contents[| i];
    if (thing.enabled) {
        script_execute(thing.render, thing, xx + argument0.element_width * i, yy);
    }
}

draw_line_colour(0, yy + argument0.element_height, xx + room_width, yy + argument0.element_height, c_black, c_black);