/// @param index

var index = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
Camera.ui.t_p_mesh_editor.element_tag.value = string(data.tags);