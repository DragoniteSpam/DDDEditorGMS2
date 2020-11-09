function omu_event_add_custom(thing) {
    var selection = ui_list_selection(thing.root.el_list_main);
    
    if (selection + 1) {
        var custom_guid = Stuff.all_event_custom[| selection].GUID;
        var node = event_create_node(Stuff.event.active, EventNodeTypes.CUSTOM, undefined, undefined, custom_guid);
    }
    
    dialog_destroy();
}