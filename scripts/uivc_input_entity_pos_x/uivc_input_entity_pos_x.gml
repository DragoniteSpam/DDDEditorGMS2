/// @param UIInput

var input = argument0;
var list = Camera.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    var thing = list[| i];
    if (thing.translateable) {        
        // you could probably do a Modification thing here but since you need
        // to deal with removing and re-adding Things into the grid this is
        // way easier
        map_move_thing(thing, real(input.value), thing.yy, thing.zz);
    }
}