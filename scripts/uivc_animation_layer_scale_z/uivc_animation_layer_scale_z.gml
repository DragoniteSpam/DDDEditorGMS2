/// @param UIInput

var input = argument0;

if (script_execute(input.validation, input.value)) {
    input.root.timeline_layer.scale_z = real(input.value);
}