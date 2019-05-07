/// @description  void uivc_select_mesh_refresh(index);
/// @param index

var index=argument0;

// refresh values that don't like to do it on their own
if (data_vra_exists()){
    var data=Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
    Camera.ui.t_p_mesh_editor.element_tag.value=string(data[@ MeshArrayData.TAGS]);
}
