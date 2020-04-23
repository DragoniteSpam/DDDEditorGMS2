/// @param Entity
/// @param DataMoveRoute
/// @param root

var entity = argument0;
var route = argument1;
var root = argument2;

var dw = 400;
var dh = 240;

var dg = dialog_create(dw, dh, "Delete Movement Route?", dialog_default, undefined, root);
dg.entity = entity;
dg.route = route;

var columns = 1;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var col1_x = dw * 0 / 3 + spacing;

var vx1 = 0;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var el_text = create_text(col1_x, yy, "Are you sure you want to delete " + route.name + "?", ew, eh, fa_left, ew, dg);
el_text.valignment = fa_top;
yy += el_text.height + spacing;

var el_yes = create_button(dw / 2 - b_width / 2 - spacing, dh - 32 - b_height / 2, "Yes", b_width, b_height, fa_center, uivc_move_route_delete, dg, fa_center);
var el_no = create_button(dw / 2 + b_width / 2 + spacing, dh - 32 - b_height / 2, "No", b_width, b_height, fa_center, dc_default, dg, fa_center);

ds_list_add(dg.contents,
    el_text,
    el_yes,
    el_no,
);

return dg;