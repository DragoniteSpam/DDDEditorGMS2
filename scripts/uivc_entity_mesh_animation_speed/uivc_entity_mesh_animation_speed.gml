/// @param UIInput

var input = argument0;

// this assumes that every selected entity is already an instance of Pawn
var list = Stuff.map.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    list[| i].animation_speed = real(input.value);
}