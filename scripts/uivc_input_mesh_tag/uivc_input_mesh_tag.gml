/// @param UIInput

var input = argument0;

if (data_vra_exists()) {
    var rv = real(input.value);
    if (is_clamped(rv, input.value_lower, input.value_upper)) {
        var data = noone;
		stack_trace();
        data[@ MeshArrayData.TAGS] = rv;
    }
}