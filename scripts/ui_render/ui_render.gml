function ui_render(thing, x, y) {
    for (var i = 0; i < ds_list_size(thing.contents); i++) {
        var what = thing.contents[| i];
        if (what.enabled) {
            if (is_struct(what)) {
                what.Render(thing.x + x, thing.y + y); 
            } else {
                what.render(what, thing.x + x, thing.y + y); 
            }
        }
    }
    
    ui_handle_dropped_files(thing);
}