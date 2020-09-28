/// @param UICheckbox
function uivc_check_entity_static(argument0) {

    var checkbox = argument0;
    var list = Stuff.map.selected_entities;

    // for things like this that are more specific than Entity check to
    // make sure that they're instanceof_classic whatever before setting/modifying
    // the value
    for (var i = 0; i < ds_list_size(list); i++) {
        entity_set_static(list[| i], checkbox.value);
    }


}
