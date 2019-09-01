/// @param UIInput

var input = argument0;

if (validate_int(input.value)) {
    var rv = real(input.value);
    if (is_clamped(rv, input.value_lower, input.value_upper)) {
        var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
        data.tags = rv;
    }
}