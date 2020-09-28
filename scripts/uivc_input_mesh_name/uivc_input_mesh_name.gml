/// @param UIInput
function uivc_input_mesh_name(argument0) {

    var input = argument0;

    var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

    if (data) {
        data.name = input.value;
    }


}
