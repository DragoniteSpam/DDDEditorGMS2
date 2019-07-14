/// @param UIThing

var list = Camera.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    var thing = list[| i];
    if (thing.translateable) {        
        map_move_thing(thing, thing.xx, thing.yy, clamp(real(argument0.value), argument0.value_lower, argument0.value_upper));
    }
}