/// @param UICheckbox

var checkbox = argument0;
var list = Stuff.map.selected_entities;

// for things like this that are more specific than Entity check to
// make sure that they're instanceof whatever before setting/modifying
// the value
for (var i = 0; i < ds_list_size(list); i++) {
    entity_set_static(list[| i], checkbox.value);
}