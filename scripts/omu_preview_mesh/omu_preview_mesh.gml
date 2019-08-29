/// @param UIButton

var button = argument0;

stack_trace();
var map = noone;
// this needs to look for the selected mesh in the Mesh Editor tab of the general UI

if (ds_map_size(map) == 1) {
    // this only works if exactly one thing is selected
    __view_set( e__VW.Visible, view_3d_preview, true );
    Camera.mesh_preview = noone;
    Camera.mesh_x = 0;
    Camera.mesh_y = 0;
    Camera.mesh_z = 0;
    Camera.mesh_xrot = 0;
    Camera.mesh_yrot = 0;
    Camera.mesh_zrot = 0;
    Camera.mesh_scale = 1;
}