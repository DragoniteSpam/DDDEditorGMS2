event_inherited();

width = 128;
height = 24;

onvaluechange = null;
render = ui_render_color_picker;

// these are similar to UIInput, but in this case the color is shown in the box
value_x1 = x;
value_y1 = y;
value_x2 = x + height;
value_y2 = y + height;
value = c_black;