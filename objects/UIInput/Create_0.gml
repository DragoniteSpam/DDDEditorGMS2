event_inherited();

width=128;
height=24;

onvaluechange=null;
render=ui_render_input;
validation=validate_string;
value_conversion=ui_value_string;

value_x1=x;
value_y1=y;
value_x2=x+height;
value_y2=y+height;
value_limit=10;
value="";
value_default="";

// these are not checked automatically because they don't apply to strings;
// you need to check them in the uivc_* scripts
value_lower=0;
value_upper=100;

