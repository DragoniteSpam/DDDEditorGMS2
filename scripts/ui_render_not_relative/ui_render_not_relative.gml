function ui_render_not_relative(thing, x, y) {
    // this is mainly so that tabs don't draw their contents relative to their own position
    // in the row, but you can use it for other things too
    for (var i = 0; i < ds_list_size(thing.contents); i++) {
        var what = thing.contents[| i];
        if (is_struct(what)) {
            what.Render(x, y); 
        } else {
            what.render(what, x, y); 
        }
    }
    
    ui_handle_dropped_files(thing);
}