/// @param Dialog

var root = argument0;
var zone = root.zone;
var map = Stuff.map.active_map;

var dw = 960;
var dh = 480;

var dg = dialog_create(dw, dh, "Camera Zone Settings: " + zone.name, dialog_default, dc_close_no_questions_asked, root);
dg.zone = zone;

var columns = 3;
var spacing = 16;
var ew = (dw - columns * spacing * 2) / columns;
var eh = 24;

var col1_x = dw * 0 / columns + spacing;
var col2_x = dw * 1 / columns + spacing;
var col3_x = dw * 2 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;

var el_name = create_input(col1_x, yy, "Name", ew, eh, uivc_input_map_camera_zone_name, zone.name, "name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
el_name.tooltip = "A name; this is for identification (and possibly debugging) purposes and has no influence on gameplay";
yy = yy + el_name.height + spacing;

var yy_base = yy;

var el_bounds_text = create_text(col1_x, yy, "Bounds", ew, eh, fa_left, ew, dg);
el_bounds_text.color = c_blue;

yy = yy + el_bounds_text.height + spacing;

var bounds_x_help = "0..." + string(map.xx);
var bounds_y_help = "0..." + string(map.yy);
var bounds_z_help = "0..." + string(map.zz);

var el_bounds_x1 = create_input(col1_x, yy, "X1:", ew, eh, uivc_input_map_camera_zone_x1, zone.x1, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
el_bounds_x1.tooltip = "The starting X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
yy = yy + el_bounds_x1.height + spacing;

var el_bounds_y1 = create_input(col1_x, yy, "Y1:", ew, eh, uivc_input_map_camera_zone_y1, zone.y1, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
el_bounds_y1.tooltip = "The starting Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
yy = yy + el_bounds_y1.height + spacing;

var el_bounds_z1 = create_input(col1_x, yy, "Z1:", ew, eh, uivc_input_map_camera_zone_z1, zone.z1, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
el_bounds_z1.tooltip = "The starting Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
yy = yy + el_bounds_z1.height + spacing;

var el_bounds_x2 = create_input(col1_x, yy, "X2:", ew, eh, uivc_input_map_camera_zone_x2, zone.x2, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
el_bounds_x2.tooltip = "The ending X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
yy = yy + el_bounds_x2.height + spacing;

var el_bounds_y2 = create_input(col1_x, yy, "Y2:", ew, eh, uivc_input_map_camera_zone_y2, zone.y2, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
el_bounds_y2.tooltip = "The ending Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
yy = yy + el_bounds_y2.height + spacing;

var el_bounds_z2 = create_input(col1_x, yy, "Z2:", ew, eh, uivc_input_map_camera_zone_z2, zone.z2, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
el_bounds_z2.tooltip = "The ending Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
yy = yy + el_bounds_z2.height + spacing;

yy = yy_base;

var el_properties_text = create_text(col2_x, yy, "Properties", ew, eh, fa_left, ew, dg);
el_properties_text.color = c_blue;

yy = yy + el_properties_text.height + spacing;

var el_camera_distance = create_input(col2_x, yy, "Distance:", ew, eh, uivc_input_map_camera_zone_distance, zone.camera_distance, "float", validate_double, 0, 32, 10, vx1, vy1, vx2, vy2, dg);
el_camera_distance.tooltip = "How far the camera is to be from its target, measured in tile distances";
yy = yy + el_camera_distance.height + spacing;

var el_camera_angle = create_input(col2_x, yy, "Angle:", ew, eh, uivc_input_map_camera_zone_angle, zone.camera_angle, "float", validate_double, -89, 89, 4, vx1, vy1, vx2, vy2, dg);
el_camera_angle.tooltip = "The angle above the ground of the camera, measured in degrees; a positive angle is looking down on the camera target, and a negative angle is looking up";
yy = yy + el_camera_angle.height + spacing;

var el_priority = create_input(col2_x, yy, "Priority:", ew, eh, uivc_input_map_camera_zone_priority, zone.zone_priority, "int", validate_int, 0, 1000, 3, vx1, vy1, vx2, vy2, dg);
el_priority.tooltip = "If multiple camera zones overlap, the one with the highest priority will be the one that is acted upon";
yy = yy + el_priority.height + spacing;

yy = yy_base;

var el_transition_text = create_text(col3_x, yy, "Transition", ew, eh, fa_left, ew, dg);
el_transition_text.color = c_blue;
yy = yy + el_transition_text.height + spacing;

var el_transition_style = create_list(col3_x, yy, "Easing Mode:", "(no easings)", ew, eh, 8, uivc_input_map_camera_zone_transition, false, dg, global.animation_tween_names);
el_transition_style.entries_are = ListEntries.STRINGS;
el_transition_style.tooltip = "The transition used when you enter this camera zone. In almost all cases, Linear or Quadratic In / Out should be fine.";
ui_list_select(el_transition_style, zone.camera_easing_method, true);
yy = yy + ui_get_list_height(el_transition_style) + spacing;

var el_transition_rate = create_input(col3_x, yy, "Time:", ew, eh, uivc_input_map_camera_zone_time, zone.camera_easing_time, "float", validate_double, 0, 60, 4, vx1, vy1, vx2, vy2, dg);
el_transition_rate.tooltip = "How long camera position transitions should take, in seconds. A speed value of 0 is an instantaneous transition, and is not recommended.";
yy = yy + el_transition_rate.height + spacing;

var b_width = 128;
var b_height = 32;
var el_commit = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_name,
    el_bounds_text,
    el_bounds_x1,
    el_bounds_y1,
    el_bounds_z1,
    el_bounds_x2,
    el_bounds_y2,
    el_bounds_z2,
    el_properties_text,
    el_camera_distance,
    el_camera_angle,
    el_priority,
    el_transition_text,
    el_transition_style,
    el_transition_rate,
    el_commit
);

return dg;