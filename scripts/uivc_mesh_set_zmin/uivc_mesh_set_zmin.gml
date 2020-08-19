/// @param UIInput
function uivc_mesh_set_zmin(argument0) {

    var input = argument0;

    var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

    if (data) {
        var old_value = data.zmin;
        data.zmin = real(input.value);
        if (old_value != data.zmin) {
            data_mesh_recalculate_bounds(data);
        }
    }


}
