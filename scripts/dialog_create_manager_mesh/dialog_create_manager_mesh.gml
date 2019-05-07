/// @description  void dialog_create_manager_mesh(Dialog);
/// @param Dialog

var dw=512;
var dh=400;

var dg=dialog_create(dw, dh, "Data: Availalbe Meshes", dialog_default, dc_manager_mesh, argument0);

var ew=(dw-64)/2;
var eh=24;

var vx1=dw/4+16;
var vy1=0;
var vx2=vx1+80;
var vy2=vy1+eh;

var b_width=128;
var b_height=32;

var el_vrax=create_text(16, 64, "Mesh file (vrax): ", ew, eh, fa_left, dw-32, dg);
el_vrax.render=ui_render_text_vrax;

var el_load=create_button(16, 96, "Load", b_width, b_height, fa_center, dmu_dialog_load_vrax, dg);
el_load.render=ui_render_button_vrax;

// we need to access this later, if you re-load the meshes
var n=ds_list_size(Stuff.all_mesh_names);
dg.el_list=create_list(16, 128, "Available meshes: "+string(n), "<no meshes>", dw/2-16, b_height, 5, uivc_list_view_mesh, false, dg);
for (var i=0; i<n; i++){
    create_list_entries(dg.el_list, Stuff.all_mesh_names[| i], c_black);
}

var bounds_x=dw/2+16;
var el_bounds=create_text(bounds_x, 128, "Bounds:", b_width, b_height, fa_left, b_width, dg);

dg.el_bounds_xmin=create_text(bounds_x, 128+32, "", b_width, b_height, fa_left, b_width, dg);
dg.el_bounds_ymin=create_text(bounds_x, 128+2*32, "", b_width, b_height, fa_left, b_width, dg);
dg.el_bounds_zmin=create_text(bounds_x, 128+3*32, "", b_width, b_height, fa_left, b_width, dg);

bounds_x=dw*3/4+16;

dg.el_bounds_xmax=create_text(bounds_x, 128+32, "", b_width, b_height, fa_left, b_width, dg);
dg.el_bounds_ymax=create_text(bounds_x, 128+2*32, "", b_width, b_height, fa_left, b_width, dg);
dg.el_bounds_zmax=create_text(bounds_x, 128+3*32, "", b_width, b_height, fa_left, b_width, dg);

dg.el_preview=create_button(dw/2-b_width-32, dh-32-b_height/2, "Preview", b_width, b_height, fa_center, dmu_dialog_preview_mesh, dg);
dg.el_preview.interactive=false;

var el_confirm=create_button(dw/2+32, dh-32-b_height/2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_vrax, el_load, dg.el_list, el_bounds, dg.el_bounds_xmin, dg.el_bounds_ymin,
    dg.el_bounds_zmin, dg.el_bounds_xmax, dg.el_bounds_ymax, dg.el_bounds_zmax, dg.el_preview, el_confirm);

keyboard_string="";

return dg;
