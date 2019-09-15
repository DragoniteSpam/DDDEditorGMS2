/// @param UIThing
/// @param EventNode
/// @param data-index

var thing = argument0;
var event_node = argument1;
var data_index = argument2;

var dw = 1440;
var dh = 800;

var dg = dialog_create(dw, dh, "Map Transfer", dialog_default, dc_close_no_questions_asked, thing);
dg.node = event_node;
dg.index = data_index;

var custom_data_map = event_node.custom_data[| 0];
var custom_data_x = event_node.custom_data[| 1];
var custom_data_y = event_node.custom_data[| 2];
var custom_data_z = event_node.custom_data[| 3];
var custom_data_direction = event_node.custom_data[| 4];

var columns = 4;
var ew = dw / columns;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = vx1 + (ew - vx1);
var vy2 = ew;

var yy = 64;
var spacing = 16;

var el_maps = create_list(16, yy, "Maps", "no maps", ew, eh, null, custom_data_map[| 0], false, dg, Stuff.all_maps);
el_maps.entries_are = ListEntries.INSTANCES;
dg.el_maps = el_maps;

yy = yy + ui_get_list_height(el_maps) + spacing * 4;

var el_text = create_text(16, yy, "Click on a location in one of the maps to set the destination", ew, eh, fa_left, ew, dg);

yy = yy + el_text.height + spacing * 4;

var el_direction = create_radio_array(16, yy, "Direction", ew, eh, null, custom_data_direction[| 0], dg);
dg.el_direction = el_direction;

var b_width = 128;
var b_height = 32;
var el_close = create_button(ew / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_maps, el_text, el_direction, el_close);

return dg;