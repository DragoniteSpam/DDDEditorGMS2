function sa_delete() {
    if (Stuff.map.selected_zone) {
        instance_activate_object(Stuff.map.selected_zone);
        instance_destroy(Stuff.map.selected_zone);
    }
    
    for (var i = ds_list_size(Stuff.map.active_map.contents.all_entities) - 1; i >= 0; i--) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        if (selected(thing)) {
            safa_delete(thing);
        }
    }
    
    selection_update_autotiles();
    selection_clear();
    ui_list_deselect(Stuff.map.ui.element_all_entities);
}