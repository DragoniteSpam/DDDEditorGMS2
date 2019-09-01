/// @param UIInput

var input = argument0;
var data = Stuff.all_meshes[| Camera.selection_fill_mesh];

if (validate_int(input.value)) {
    var rv = real(input.value);
    if (is_clamped(rv, input.value_lower, input.value_upper) && data) {
        data.tags = rv;
    }
}