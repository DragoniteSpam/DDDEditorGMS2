/// @description uimu_mesh_tag_up(UIThing);
/// @param UIThing

if (data_vra_exists()) {
    var data=Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
    data[@ MeshArrayData.TAGS]=++data[@ MeshArrayData.TAGS]%TileTerrainTags.FINAL;;
    
    uivc_select_mesh_refresh(Camera.selection_fill_mesh);
}
