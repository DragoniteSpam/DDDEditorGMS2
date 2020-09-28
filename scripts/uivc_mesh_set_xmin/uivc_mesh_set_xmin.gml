/// @param UIInput
function uivc_mesh_set_xmin(argument0) {

    var input = argument0;

    var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

    if (data) {
        var old_value = data.xmin;
        data.xmin = real(input.value);
        if (old_value != data.xmin) {
            data_mesh_recalculate_bounds(data);
        }
    }


}
