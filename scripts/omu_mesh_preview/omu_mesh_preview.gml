/// @param UIButton

var button = argument0;

var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

if (data) {
    view_set_visible(view_3d_preview, true);
    Stuff.mesh_preview = data;
    Stuff.mesh_x = 0;
    Stuff.mesh_y = 0;
    Stuff.mesh_z = 0;
    Stuff.mesh_xrot = 0;
    Stuff.mesh_yrot = 0;
    Stuff.mesh_zrot = 0;
    Stuff.mesh_scale = 1;
}