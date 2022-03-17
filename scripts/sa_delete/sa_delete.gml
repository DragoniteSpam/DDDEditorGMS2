function sa_delete() {
    if (Stuff.map.selected_zone) Stuff.map.selected_zone.Destroy();
    
    for (var i = ds_list_size(Stuff.map.active_map.contents.all_entities) - 1; i >= 0; i--) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        if (selected(thing)) {
            selection_delete(thing);
        }
    }
    
    selection_update_autotiles();
    selection_clear();
    Stuff.map.ui.SearchID("ALL ENTITIES").Deselect();
}