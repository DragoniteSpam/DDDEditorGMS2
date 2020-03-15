/// @param UIButton

var root = argument0;
var mesh = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

if (!mesh) {
    return;
}

var dw = 960;
var dh = 800;

// todo cache the custom event and only commit the changes when you're done
var dg = dialog_create(dw, dh, "Mesh Preview", dialog_default, dc_close_no_questions_asked, root);
dg.mesh = mesh;

var columns = 3;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var col1_x = dw * 0 / columns + spacing;
var col2_x = dw * 1 / columns + spacing;
var col3_x = dw * 2 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var b_width = 128;
var b_height = 32;

var n_slots = 20;

var yy = 64;

var el_surface = create_render_surface(col1_x, yy, 640 - spacing, 640 - spacing, ui_render_surface_render_mesh_preview, null, dg);

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_close_no_questions_asked, dg);
dg.el_confirm = el_confirm;

ds_list_add(dg.contents,
    el_surface,
    el_confirm
);

return dg;