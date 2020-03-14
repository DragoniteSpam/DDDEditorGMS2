/// @param UIButton

var button = argument0;
var map = button.root.map;
var base_ui = button.root.root.root;

ui_input_set_value(base_ui.el_dim_x, string(map.xx));
ui_input_set_value(base_ui.el_dim_y, string(map.yy));
ui_input_set_value(base_ui.el_dim_z, string(map.zz));

dialog_destroy();