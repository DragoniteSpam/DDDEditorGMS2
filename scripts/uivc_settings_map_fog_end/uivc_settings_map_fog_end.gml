/// @param UIThing

var thing = argument0;

var rv = real(thing.value);
if (is_clamped(rv, thing.value_lower, thing.value_upper)) {
    Stuff.active_map.fog_end = rv;
}