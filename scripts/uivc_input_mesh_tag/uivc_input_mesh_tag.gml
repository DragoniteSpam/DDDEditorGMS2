/// @description uivc_input_mesh_tag(UIInput);
/// @param UIInput

if (data_vra_exists()&&script_execute(argument0.validation, argument0.value)) {
    var rv=real(argument0.value);
    if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
        var data=Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
        data[@ MeshArrayData.TAGS]=rv;
    }
}
