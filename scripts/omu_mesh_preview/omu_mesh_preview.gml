/// @param UIButton

var button = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];

if (data) {
    view_set_visible(view_3d_preview, true);
    Camera.mesh_preview = data;
    Camera.mesh_x = 0;
    Camera.mesh_y = 0;
    Camera.mesh_z = 0;
    Camera.mesh_xrot = 0;
    Camera.mesh_yrot = 0;
    Camera.mesh_zrot = 0;
    Camera.mesh_scale = 1;
}