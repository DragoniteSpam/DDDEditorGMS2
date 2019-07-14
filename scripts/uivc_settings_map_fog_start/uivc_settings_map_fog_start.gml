/// @param UIThing

var rv = real(argument0.value);
if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
    ActiveMap.fog_start = rv;
}