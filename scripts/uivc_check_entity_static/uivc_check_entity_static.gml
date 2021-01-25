function uivc_check_entity_static(checkbox) {
    var list = Stuff.map.selected_entities;
    // for things like this that are more specific than Entity check to
    // make sure that they're instanceof_classic whatever before setting/modifying
    // the value
    for (var i = 0; i < ds_list_size(list); i++) {
        list[| i].SetStatic(checkbox.value);
    }
}
