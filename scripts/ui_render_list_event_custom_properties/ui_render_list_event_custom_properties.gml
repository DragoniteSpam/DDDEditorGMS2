function ui_render_list_event_custom_properties(list, x, y) {
    var otext = list.text;
    
    list.text += " (" + string(array_length(list.root.event.types)) + ")";
    ds_list_clear(list.entries);
    
    // since these are just arrays and not instances we have to do this the hard way
    // @gml update lwo
    for (var i = 0; i < array_length(list.root.event.types); i++) {
        var property = list.root.event.types[i];
        ds_list_add(list.entries, property[EventNodeCustomData.NAME]);
    }
    
    ui_render_list(list, x, y);
    
    list.text = otext;
}