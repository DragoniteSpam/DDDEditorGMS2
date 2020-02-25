/// @param UIImageButton
/// @param x
/// @param y

var button = argument0;
var xx = argument1;
var yy = argument2;
var list = button.root.el_list;
var selection = ui_list_selection(list);

ui_render_image_button(button, xx, yy);

if (selection + 1) {
    var data = list.entries[| selection];
    
    var x1 = button.x + xx;
    var y1 = button.y + yy;
    var x2 = x1 + button.width;
    var y2 = y1 + button.height;
    
    surface_set_target(button.surface);
    draw_line_width_colour(0, 0, data.width, 0, 2, c_blue, c_blue);
    draw_line_width_colour(0, 0, 0, data.height, 2, c_blue, c_blue);
    draw_line_width_colour(0, data.height, data.width, data.height, 2, c_blue, c_blue);
    draw_line_width_colour(data.width, 0, data.width, data.height, 2, c_blue, c_blue);
    surface_reset_target();
    
    draw_surface(button.surface, x1, y1);
}