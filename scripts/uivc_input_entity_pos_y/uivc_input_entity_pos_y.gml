/// @param UIInput

var input = argument0;

var list = Stuff.map.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    var thing = list[| i];
    if (thing.translateable) {
        map_move_thing(thing, thing.xx, real(input.value), thing.zz);
    }
}