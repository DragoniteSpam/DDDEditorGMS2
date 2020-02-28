/// @param Dialog

var dialog = argument0;
var list = Stuff.map.selected_entities;

var dw = 640;
var dh = 480;

var dg = dialog_create(dw, dh, "Effect Component: Lighting", dialog_default, dc_close_no_questions_asked, dialog);

var spacing = 16;
var columns = 2;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var col1_x = spacing;
var col2_x = dw / 2 + spacing;

var vx1 = dw / (columns * 2) - 32;
var vy1 = 0;
var vx2 = vx1 + dw / (columns * 2);
var vy2 = vy1 + eh;

var yy = 64;
var yy_base = yy;

var el_type = create_radio_array(col1_x, yy, "Type", ew, eh, uivc_entity_effect_com_lighting_type, 0, dg);
create_radio_array_options(el_type, ["None", "Directional", "Point", "Spot (Cone)"]);
el_type.contents[| 3].interactive = false;
el_type.tooltip = "The lighting data to be attached to this effect.\n - Directional lights are infinite an illuminate everything\n - Point lights illuminate everything within a radius, fading out smoothly\n - Spot lights can be thought of as a combination of point and directional lights, illuminating everything in a certain direction";

yy = yy + ui_get_radio_array_height(el_type) + spacing;

var el_color = create_color_picker(col1_x, yy, "Light color:", ew, eh, null, c_white, vx1, vy1, vx2, vy2, dg);
el_color.tooltip = "The color of the light. White is fine, in most cases. Black makes no sense.";
el_color.enabled = false;
dg.el_color = el_color;

yy = yy + el_color.height + spacing;

#region directional lights
yy = yy_base;

var el_dir_x = create_input(col2_x, yy, "X:", ew, eh, null, 0, "float", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, dg);
el_dir_x.tooltip = "The X component of the light direction vector.";
el_dir_x.enabled = false;
dg.el_dir_x = el_dir_x;

yy = yy + el_dir_x.height + spacing;

var el_dir_y = create_input(col2_x, yy, "Y:", ew, eh, null, 0, "float", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, dg);
el_dir_y.tooltip = "The Y component of the light direction vector.";
el_dir_y.enabled = false;
dg.el_dir_y = el_dir_y;

yy = yy + el_dir_y.height + spacing;

var el_dir_z = create_input(col2_x, yy, "Z:", ew, eh, null, 0, "float", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, dg);
el_dir_z.tooltip = "The Z component of the light direction vector.";
el_dir_z.enabled = false;
dg.el_dir_z = el_dir_z;

yy = yy + el_dir_z.height + spacing;
#endregion

#region point lights
yy = yy_base;

var el_point_x = create_input(col2_x, yy, "X:", ew, eh, null, 0, "float", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, dg);
el_point_x.tooltip = "The X offset of the light point.";
el_point_x.enabled = false;
dg.el_point_x = el_point_x;

yy = yy + el_dir_x.height + spacing;

var el_point_y = create_input(col2_x, yy, "Y:", ew, eh, null, 0, "float", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, dg);
el_point_y.tooltip = "The Y offset of the light point.";
el_point_y.enabled = false;
dg.el_point_y = el_point_y;

yy = yy + el_point_y.height + spacing;

var el_point_z = create_input(col2_x, yy, "Z:", ew, eh, null, 0, "float", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, dg);
el_point_z.tooltip = "The Z offset of the light point.";
el_point_z.enabled = false;
dg.el_point_z = el_point_z;

yy = yy + el_point_z.height + spacing;

var el_point_radius = create_input(col2_x, yy, "Radius:", ew, eh, null, 0xff, "float", validate_double, 0.1, 0xffffff, 10, vx1, vy1, vx2, vy2, dg);
el_point_radius.tooltip = "The radius of the point light. A value between 100 and 1000 is normally fine. A value that's very small or very large doesn't make much sense, but will still work.";
el_point_radius.enabled = false;
dg.el_point_radius = el_point_radius;

yy = yy + el_point_radius.height + spacing;
#endregion

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_type,
    el_color,
    el_dir_x,
    el_dir_y,
    el_dir_z,
    el_point_x,
    el_point_y,
    el_point_z,
    el_point_radius,
    el_confirm
);

return dg;