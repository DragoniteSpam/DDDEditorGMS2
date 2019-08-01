/// @param UIThing

var thing = argument0;

if (thing.root.root.root.active_animation) {
    if (!internal_name_get(thing.value)) {
        internal_name_set(thing.root.root.root.active_animation, thing.value);
    }
}