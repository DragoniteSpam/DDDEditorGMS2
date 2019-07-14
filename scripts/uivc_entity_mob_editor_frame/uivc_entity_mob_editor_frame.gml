/// @param UIThing

// this assumes that every selected entity is already an instance of Pawn
var list = Camera.selected_entities;

var conversion = script_execute(argument0.value_conversion, argument0.value);
for (var i = 0; i < ds_list_size(list); i++) {
    list[| i].frame = conversion;
}