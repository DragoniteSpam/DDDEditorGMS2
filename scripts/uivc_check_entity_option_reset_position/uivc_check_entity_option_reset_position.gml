/// @param UIThing

var thing = argument0;
var list = Camera.selected_entities;

// for things like this that are more specific than Entity check to
// make sure that they're instanceof whatever before setting/modifying
// the value
for (var i = 0; i < ds_list_size(list); i++) {
    entity_set_option_reset_position(list[| i], thing.value);
}