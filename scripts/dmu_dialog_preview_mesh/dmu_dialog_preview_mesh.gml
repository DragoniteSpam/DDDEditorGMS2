/// @description  void dmu_dialog_preview_mesh(UIButton);
/// @param UIButton

var map=argument0.root.el_list.selected_entries;

if (ds_map_size(map)==1){
    // this only works if exactly one thing is selected
    __view_set( e__VW.Visible, view_3d_preview, true );
    Camera.mesh_preview=Stuff.vra_data[? Stuff.all_mesh_names[| ds_map_find_first(map)]];
    Camera.mesh_x=0;
    Camera.mesh_y=0;
    Camera.mesh_z=0;
    Camera.mesh_xrot=0;
    Camera.mesh_yrot=0;
    Camera.mesh_zrot=0;
    Camera.mesh_scale=1;
}
