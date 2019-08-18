event_inherited();

width = 128;
height = 24;

onvaluechange = null;
render = ui_render_input;
validation = validate_string;
value_conversion = ui_value_string;
require_enter = false;

// you could determine this by looking at the validation script, but that's going
// to get messy if too many more of them are added - and since you're not supposed
// to change the validation script after setting it, you can get away with cacheing it
real_value = false;

value_x1 = x;
value_y1 = y;
value_x2 = x + height;
value_y2 = y + height;
value_limit = 10;
value = "";
value_default = "";
back_color = c_white;

// these are not checked automatically because they don't apply to strings;
// you need to check them in the uivc_* scripts
value_lower = 0;
value_upper = 100;