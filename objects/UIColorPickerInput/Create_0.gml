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

color_x = x;
color_y = y + height;
main_size = 128;                    // side length

axis_x = color_x + main_size + 16;
axis_y = color_y;
axis_width = 48;

output_x = color_x;
output_y = color_y + main_size + 16;
output_height = 16;

alpha_x = output_x;
alpha_y = output_y + main_size + 16;
alpha_height = 16;

axis_value = 0;
axis_channel = ColorChannels.R;

enum ColorChannels {
    R, G, B, A
}