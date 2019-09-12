/// @param UIThing

var thing = argument0;

// this assumes that every selected entity is already an instance of Pawn
var list = Camera.selected_entities;

var conversion = real(thing.value);
for (var i = 0; i < ds_list_size(list); i++) {
    list[| i].frame = conversion;
}