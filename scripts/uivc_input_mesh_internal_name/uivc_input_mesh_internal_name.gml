/// @param UIInput
function uivc_input_mesh_internal_name(argument0) {

    var input = argument0;

    var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

    if (data) {
        internal_name_set(data, input.value);
    }


}
