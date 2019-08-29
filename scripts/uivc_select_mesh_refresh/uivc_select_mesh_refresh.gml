/// @param index

var index = argument0;

// refresh values that don't like to do it on their own
if (data_vra_exists()) {
    var data = noone;
	stack_trace();
    Camera.ui.t_p_mesh_editor.element_tag.value = string(data[@ MeshArrayData.TAGS]);
}