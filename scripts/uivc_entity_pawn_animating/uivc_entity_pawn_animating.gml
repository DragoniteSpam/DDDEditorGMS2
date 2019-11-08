/// @param UIThing

var thing = argument0;

// this assumes that every selected entity is already an instance of Pawn
var list = Stuff.map.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    list[| i].is_animating = thing.value;
}