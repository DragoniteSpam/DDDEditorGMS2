event_inherited();

width = 128;
height = 24;

onvaluechange = null;
render = ui_render_color_picker_input;
text = "Color";

// these are similar to UIInput, but in this case the color is shown in the box
value_x1 = x;
value_y1 = y;
value_x2 = x + height;
value_y2 = y + height;
value = c_black;
value_text = "00000000";
alpha = 1;

allow_alpha = true;

color_x = 0;
color_y = height + 16;
main_size = 176;                    // side length
selecting_color = false;

axis_x = color_x + main_size + 16;
axis_y = color_y;
axis_width = 32;
// axis_height is main_size
selecting_axis = false;

output_x = color_x + 48;
output_y = color_y + main_size + 8;
// output_width is main_size
output_height = 16;

alpha_x = color_x + 48;
alpha_y = output_y + output_height + 8;
// alpha_width is main_size
alpha_height = 16;
selecting_alpha = false;

axis_value = 0;
axis_channel = ColorChannels.R;

enum ColorChannels {
    R, G, B, A
}