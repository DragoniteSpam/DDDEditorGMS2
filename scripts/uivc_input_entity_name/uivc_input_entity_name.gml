/// @description uivc_input_entity_name(UIThing);
/// @param UIThing

var list=Camera.selected_entities;

// for things like this that are more specific than Entity check to
// make sure that they're instanceof whatever before setting/modifying
// the value
for (var i=0; i<ds_list_size(list); i++) {
    list[| i].name=argument0.value;
}
