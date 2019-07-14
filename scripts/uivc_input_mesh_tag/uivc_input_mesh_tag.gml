/// @param UIInput

if (data_vra_exists()) {
    var rv = real(argument0.value);
    if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
        var data = Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
        data[@ MeshArrayData.TAGS] = rv;
    }
}