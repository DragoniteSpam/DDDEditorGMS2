/// @param Dialog
/// @param format-index

var root = argument0;
var format_index = argument1;
var mode = Stuff.mesh_ed;

var dw = 720;
var dh = 480;

var dg = dialog_create(dw, dh, "Vertex Format Settings", dialog_default, dc_close_no_questions_asked, root);
dg.format_index = format_index;

var columns = 2;
var ew = dw / columns - 64;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var c1x = 0 * dw / columns + 32;
var c2x = 1 * dw / columns + 32;
var spacing = 16;

var yy = 64;
var yy_start = 64;

var el_name = create_input(c1x, yy, "Name: ", ew, eh, null, mode.format_names[| format_index], "string", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
yy += el_name.height;

var el_list = create_list(c1x, yy, "Attributes: ", "no attributes", ew, eh, 12, null, false, dg);
yy += ui_get_list_height(el_list) + spacing;

yy = yy_start;

var el_attribute_label = create_text(c2x, yy, "[c_blue]Attributes", ew, eh, fa_left, ew, dg);
yy += el_name.height;

var el_attribute_name = create_input(c2x, yy, "Name: ", ew, eh, null, mode.format_names[| format_index], "string", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
yy += el_attribute_name.height;

var el_attribute_type = create_radio_array(c2x, yy, "Type:", ew, eh, null, -1, dg);
create_radio_array_options(el_attribute_type, ["Position (2D)", "Position (3D)", "Normal", "Texture Coordinate", "Color"]);
yy += ui_get_radio_array_height(el_attribute_type) + spacing;

var format = mode.formats[| format_index];
var attributes = format[? "attributes"];
for (var i = 0; i < ds_list_size(attributes); i++) {
    var att = attributes[| i];
    wtf([att[? "name"], att[? "type"]]);
}

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_name, el_list,
    el_attribute_label, el_attribute_name, el_attribute_type,
    el_confirm
);

return dg;