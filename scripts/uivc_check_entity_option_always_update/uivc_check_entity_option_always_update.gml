/// @param UIThing

var thing = argument0;
var list = Stuff.map.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    entity_set_option_always_update(list[| i], thing.value);
}