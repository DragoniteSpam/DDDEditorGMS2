/// @param index

var index = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
Camera.ui.t_p_mesh_editor.element_tag = (data && true);

if (data) {
    var thing = Camera.ui.t_p_mesh_editor;
    thing.element_tag.value = string(data.tags);
    thing.mesh_name.value = data.internal_name;
    
    thing.xmin.value = string(data.xmin);
    thing.xmax.value = string(data.xmax);
    thing.ymin.value = string(data.ymin);
    thing.ymax.value = string(data.ymax);
    thing.zmin.value = string(data.zmin);
    thing.zmax.value = string(data.zmax);
}